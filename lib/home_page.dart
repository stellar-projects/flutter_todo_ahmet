import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

///Yorumlar
///Öncelikle eline sağlık, uygulama güzel çalışıyor. İlk aşamayı topaladığına göre mevcut yapıda birkaç geri bildirimim olucak.
/// 1- Kod yazarken her zaman aklında olması gereken ilk kural DRY prensibi, yani "Don't repeat yourself". İlk gözüme çarpan şey kimi parametrelerin tekrarlayan yapıca olması oldu. Örnek;
/// todo.keys.toList()[index] ve todo.values.toList()[index]  çağtıları. bunları listview builder'in en başında var key = todo.keys.toList()[index]; ve var isChecked = todo.values.toList()[index].
/// şeklinde yazıp kodun kalan kısmında o şekilde kullanman daha doğru olur.
/// 2- Değişken isimlendirmeleri: kod yazarken her zaman aklında senden sonra gelecek kişinin de o kodu okuması gerekebileceğini aklında tutman gerekiyor. o yüzden değişken isimlerin her zaman açıklayıcı olsun.
/// örnek vermek gerekirse todo.values.toList()[index] değeri için var isChecked = todo.values.toList()[index]; yazıp ilgili alanlardan isChecked değişkenini kullanman proje okunabilirliği ve ilerleyen zamanlarda bakımı yapılabilmesi açısından daha güzel olur.
/// 3- Kontrol metodların build(context) alanı içerisinde çalışmasın. Bu metodlar build(context) alanının üstünde ayrı bir metod olarak dursun.
/// 4- showDialog çağrısı için setState metodunu çağırman gerekmiyor
/// 5- Mecbur kalmadıkça 'Force Unwrapping' yapma. yani check box'i işaretlerken yaptığın "newValue!" yerine "newValue ?? false" yapman daha doğru olur. eğer bir parametre optional ise optinaldır, null gelmme ihtimali var demektir. ve bu değer null gelirse 'newValue!" çağtısı hata vericektir.
/// 6- Map kullanımında map[key]=value; yaklaşımını kullanman yeterlidir. update(..) metodu gereksiz
/// 7- ListView oluştururken map.keys.toList() kullanımı başlangıçta işini görür gibi gözükse de map.keys ile oluşturulan array'in her zaman doğru sırada gelme mecburiyeti yok. zamanla liste sıralaması değişebilir.
/// 8- daha doğru bir yaklaşım bu iş için bir map kullanmaktansa bir TodoItem class'ı oluşturup onların parametreleri üzerinden çalışmak olur.
/// 9- Yine mevcut yapıda satırlarının "primary key" değerleri map olduğu için birden fazla aynı todo satırını kabul etmiyor. Primary key değerinin her zaman tek olmasını garnatilemen gerekiyor. Bu yüzden class yapısı + array şeklinde ilerlemen önemli.

///Todo listesi için class. Bu şekilde gelecekte eklenmesi muhtemel yeni parametreler kolayca sşsteme eklenebilir.
///
///
/// Shared Preferences için adımlar:
/// 0- Json serialization araştırılması gerken konular. Dart:Convert kütüphanesi ve JsonToDart plugini
/// 1- Todo Nesnesinin json string olarak kaydedilmesi
/// 2- Json nesnesinden todo objelerinin oluşturulması
///
///
/// 06-10-2022 İncelemeler
/// 1- Her fonksiyonu setState içerisine alman gerekmiyor.
/// 2- setState fonksiyonu main thread üzerinde çalışmaktadır, o yüzden genelde asenkron çağrılar setState'ten önce tamamlanır, devamında setState çalıştırılır. _loadPrefs() fonksiyonunda not ekledim
/// 3- loadPrefs fonksiyonunu her save'den sonra çalıştırman gerekmiyor. zaten senin veri modelin 'List<TodoItem> items = [];' olarak memory de yüklenmiş durumda.
/// 4- o yüzden sadece veriyi senkronize etmek adına setState sonrasında savePrefs metodunu çalıştırman yeterli olucaktır.
/// 5- savePrefs metodunun her güncellemeden sonra çağırılması aslında kod temizliği açısından doğru olmasada mevcut Model-View-Controller mimarisine uygun.
/// 6- Normalde bu tarz işlerde MVVM tarzı bir yaklaşım ile TodoItem modelimiz için bir ViewModel oluşturup değişimlerde güncelleme işlemini oraya taşımamız gerekiyor
/// 7- Fakat flutter'da ben daha çok Bloc mimarisi taraftarıyım. ilerleyen adımlarda o konuya da değiniyor olacağız.
/// 8- aslınd initState() metodu içerisinde herhangi bir asenkron işlem sonrasında "setState" çağrısı yapıcak bir metod kullanıyor isek onu SchedulerBinding.instance.addPostFrameCallback içerisinden çağırmakta fayda var.
/// 8- kimi durumlarda daha ilk frame oluşturulmadan setState çağrısı yapılabilir ve bu da hata olmasına sebep olur. bu fonksiton ilgili metodun bir sonraki (veya ilk) frame oluşturuldukan sonra çalıştırılmasını garanti ediyor
class TodoItem {
  String text;
  bool isChecked;
  File? file;
  TodoItem(this.text, this.isChecked, this.file);

  Map<String, dynamic> toJson() {
    return {"text": text, "isChecked": isChecked, "file": file?.path};
  }

  static TodoItem fromJson(Map<String, dynamic> json) {
    return TodoItem(json["text"], json["isChecked"],
        json["file"] == null ? null : File(json["file"]));
  }
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  final FocusNode focusNode = FocusNode();

  List<TodoItem> items = [];

  TextEditingController userInput = TextEditingController();

  String text = "";
  ImagePicker image = ImagePicker();

  late final SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    //_initSharedPrefs();
    // _loadPrefs();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _loadPrefs();
    });
  }

  /*void _initSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }*/


  void _loadPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var todoString = sharedPreferences.get("todo");

    ///Serdar Düzenlenmiş kod
    if (todoString is String) {
      var todoItems = jsonDecode(todoString);
      if (todoItems is List) {
        // for (var json in todoItems) {
        //   items.add(TodoItem.fromJson(json));
        // }
        items = todoItems.map((e) => TodoItem.fromJson(e)).toList();
      }
    }
    /// Set State işlem tamamlandıktan sonra çağırılabilir.
    setState(() {});
    /// Ahmet - Eski Kod
    // print("---LOAD----");
    // setState(() {
    //   if (todoString is String) {
    //     var todoItems = jsonDecode(todoString);
    //     if (todoItems is List) {
    //       // for (var json in todoItems) {
    //       //   items.add(TodoItem.fromJson(json));
    //       // }
    //       items = todoItems.map((e) => TodoItem.fromJson(e)).toList();
    //     }
    //   }
    // });
  }

  _savePrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String json = jsonEncode(items);
    print("***SAVE***");
    sharedPreferences.setString("todo", json);
  }

  _onTapTakePhotoWithCamera(TodoItem item) async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      item.file = File(img!.path);

      // _loadPrefs();
    });
    _savePrefs();
  }

  _onTapSelectImageFromGallery(TodoItem item) async {
    image.pickImage(source: ImageSource.gallery).then((img) {
      if (img != null) {
        setState(() {
          item.file = File(img.path);
          // _savePrefs();
          // _loadPrefs();
        });
        _savePrefs();
      }
    }).catchError((error) {
      debugPrint("Hata: $error");

      /// Hata olduğu zaman çalışır
    }).whenComplete(() {
      ///Herşey tamamlandığı zaman çalışır
    });

    /*try {
      var img = await image.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          item.file = File(img.path);
        });
      }
    } catch (exception) {
      ///
    }*/
  }

  void _onTapDeleteRow(TodoItem item) {
    setState(() {
      items.remove(item);
      // _savePrefs();
    });
    _savePrefs();
  }

  void _onTapAddNewRow(String text) {
    focusNode.unfocus();

    ///Klavye gizlemek için
    setState(() {
      items.add(TodoItem(text, false, null));
      // _savePrefs();
      userInput.clear();
    });
    _savePrefs();
    //print(todo);
  }

  void _onTapUpdateRow(TodoItem item) {
    text = item.text;

    ///Açışılta initialize edilmesi gerek.
    showDialog(
      context: context,
      builder: ((context) => SimpleDialog(
            children: [
              TextFormField(
                onChanged: ((value) {
                  text = value;
                }),
                initialValue: item.text,
              ),
              ElevatedButton(
                  onPressed: (() {
                    setState(() {
                      item.text = text;
                      _savePrefs();
                      _loadPrefs();
                    });
                    Navigator.pop(context);
                    //print(todo);
                  }),
                  child: const Text("Güncelle")),
            ],
          )),
    );
  }

  void _onTapCheck(TodoItem item, bool isChecked) {
    setState(() {
      item.isChecked = isChecked;
      _savePrefs();
    });
  }

  @override
  Widget build(BuildContext context) {
    /* Aslında her setState'den sonra _savePrefs ve _loadPrefs yapmak yerine
      setState'ler build kısmını tetikleyeceği için tam buraya _savePrefs ve _loadPrefs eklemeliyim.
      Yada alternatif başka bir yaklaşım var mı?
    */
    return Scaffold(
        appBar: AppBar(title: const Text("ToDo APP")),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.teal, width: 3),
                        borderRadius: BorderRadius.circular(20.0)),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(item.text,
                              style: TextStyle(
                                  decoration: item.isChecked
                                      ? TextDecoration.lineThrough
                                      : null)),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              color: Colors.black12,
                              child: item.file == null
                                  ? const Icon(Icons.image)
                                  : Image.file(
                                      item.file!,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      _onTapTakePhotoWithCamera(item);
                                    },
                                    icon: const Icon(Icons.camera_alt)),
                                IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                      _onTapSelectImageFromGallery(item);
                                    },
                                    icon: const Icon(
                                        Icons.photo_library_rounded)),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (newValue) {
                        _onTapCheck(item, newValue ?? false);
                        // _loadPrefs();
                      },
                      activeColor: Colors.orange,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          iconSize: 20,
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _onTapDeleteRow(item);
                            //print(todo);
                          },
                        ),
                        IconButton(
                          iconSize: 20,
                          color: Colors.black,
                          onPressed: item.isChecked
                              ? null
                              : () => _onTapUpdateRow(item),
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: [
                  TextFormField(
                    controller: userInput,
                    decoration: const InputDecoration(
                      hintText: "Yeni görev ekleyiniz..",
                    ),
                    focusNode: focusNode,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _onTapAddNewRow(userInput.text);
                        // _loadPrefs();
                      },
                      child: const Text("Ekle"))
                ],
              ),
            )
          ],
        ));
  }
}
