import 'package:app_todo/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo_bloc/todo_bloc.dart';

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
  void dispose() {
    _bloc.close(); ///Bloclar mutlaka kapatılmalıdır.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.add(EventLoadItems());
    });
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
                    });
                    Navigator.pop(context);
                    //print(todo);
                  }),
                  child: const Text("Güncelle")),
            ],
          )),
    );
  }

  void _handleBlocStates(BuildContext context, state){
    if(state is StateDidLoadItems){
      setState(() {
        items = state.items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ToDo APP")),
        body: BlocListener(
          bloc: _bloc,
          listener: _handleBlocStates,
          child: Column(
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
                                        _bloc.add(
                                            EventTakePhotoWithCamera(item));
                                      },
                                      icon: const Icon(Icons.camera_alt)),
                                  IconButton(
                                      iconSize: 20,
                                      onPressed: () {
                                        _bloc.add(EventSelectImageFromGallery(item));
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
                          _bloc.add(EventCheck(item, newValue ?? false));
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
                              _bloc.add(EventDeleteItem(index));
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
                          //_onTapAddNewRow(userInput.text);
                          focusNode.unfocus();
                          _bloc.add(EventAddNewItem(userInput.text));
                          userInput.clear();
                        },
                        child: const Text("Ekle")),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}

class WidgetTodoItem extends StatelessWidget {
  final TodoItem item;
  const WidgetTodoItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
