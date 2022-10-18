import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'todo_bloc/todo_bloc.dart';
import 'todo_model.dart';

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
  //ImagePicker image = ImagePicker();

  late final SharedPreferences sharedPreferences;

  final TodoBloc _bloc = TodoBloc();

  @override
  void initState() {
    super.initState();
    //_initSharedPrefs();

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
  }

  _savePrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String json = jsonEncode(items);
    print("***SAVE***");
    sharedPreferences.setString("todo", json);
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
                      //_loadPrefs();
                    });
                    Navigator.pop(context);
                    //print(todo);
                  }),
                  child: const Text("Güncelle")),
            ],
          )),
    );
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
                                BlocListener(
                                  bloc: _bloc,
                                  listener: (context, state) {
                                    if (state is StateTakePhotoWithCamera) {
                                      setState(() {
                                        item = state.item;
                                      });
                                      _savePrefs();
                                    }
                                  },
                                  child: IconButton(
                                      iconSize: 20,
                                      onPressed: () {
                                        _bloc.add(
                                            EventTakePhotoWithCamera(item));
                                      },
                                      icon: const Icon(Icons.camera_alt)),
                                ),
                                BlocListener(
                                  bloc: _bloc,
                                  listener: (context, state) {
                                    if (state is StateSelectImageFromGallery) {
                                      setState(() {
                                        item = state.item;
                                      });
                                      _savePrefs();
                                    }
                                  },
                                  child: IconButton(
                                      iconSize: 20,
                                      onPressed: () {
                                        _bloc.add(
                                            EventSelectImageFromGallery(item));
                                      },
                                      icon: const Icon(
                                          Icons.photo_library_rounded)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    leading: BlocListener(
                      bloc: _bloc,
                      listener: (context, state) {
                        if (state is StateIsChecked) {
                          setState(() {
                            item = state.item;
                          });
                          _savePrefs();
                          print(item.text);
                          print(item.isChecked);
                        }
                      },
                      child: Checkbox(
                        value: item.isChecked,
                        onChanged: (newValue) {
                          _bloc.add(EventCheck(item, newValue ?? false));
                        },
                        activeColor: Colors.orange,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocListener(
                          bloc: _bloc,
                          listener: (context, state) {
                            if (state is StateDeleteItem) {
                              setState(() {
                                items = state.items;
                              });
                              _savePrefs();
                            }
                          },
                          child: IconButton(
                            iconSize: 20,
                            color: Colors.red,
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _bloc.add(EventDeleteItem(items, index));
                              //print(todo);
                            },
                          ),
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
                  BlocListener(
                    bloc: _bloc,
                    listener: (context, state) {
                      if (state is StateAddItem) {
                        setState(() {
                          items = state.items;
                        });
                        _savePrefs();
                      }
                    },
                    child: ElevatedButton(
                        onPressed: () {
                          //_onTapAddNewRow(userInput.text);
                          focusNode.unfocus();
                          _bloc.add(EventAddNewItem(items, userInput.text));
                          userInput.clear();
                        },
                        child: const Text("Ekle")),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
