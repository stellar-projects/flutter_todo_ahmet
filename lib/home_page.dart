import 'package:flutter/material.dart';

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
class TodoItem{
  String text;
  bool isChecked;
  TodoItem(this.text, this.isChecked);
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {


  final List<TodoItem> items = List.generate(4, (index) => TodoItem("Todo Item $index", false));

  TextEditingController userInput = TextEditingController();

  String text = "";

  void _onTapDeleteRow(TodoItem item){
    setState(() {
      items.remove(item);
    });
  }

  void _onTapAddNewRow(String text){
    setState(() {
      items.add(TodoItem(text, false));
      userInput.clear();
    });
    //print(todo);
  }

  void _onTapUpdateRow(TodoItem item){
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
                  });
                  Navigator.pop(context);
                  //print(todo);
                }),
                child: const Text("Güncelle")),
          ],
        )),
      );
  }

  void _onTapCheck(TodoItem item, bool isChecked){
    setState(() {
      item.isChecked = isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    title: Text(item.text,
                        style: TextStyle(
                            decoration: item.isChecked ? TextDecoration.lineThrough : null)),
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (newValue) => _onTapCheck(item, newValue ?? false),
                      activeColor: Colors.orange,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _onTapDeleteRow(item);
                            //print(todo);
                          },
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: item.isChecked ? null : () => _onTapUpdateRow(item),
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
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
                      labelText: "Yeni görev ekleyiniz..",
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () =>_onTapAddNewRow(userInput.text),
                      child: const Text("Ekle"))
                ],
              ),
            )
          ],
        ));
  }
}


