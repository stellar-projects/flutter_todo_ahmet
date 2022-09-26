import 'package:flutter/material.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  Map<String, bool> todo = {
    "Task 1": false,
    "Task 2": false,
    "Task 3": false,
    "Task 4": false,
  };

  TextEditingController userInput = TextEditingController();

  String text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ToDo APP")),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: todo.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.teal, width: 3),
                        borderRadius: BorderRadius.circular(20.0)),
                    title: Text(todo.keys.toList()[index],
                        style: TextStyle(
                            decoration: todo.values.toList()[index]
                                ? TextDecoration.lineThrough
                                : null)),
                    leading: Checkbox(
                      value: todo.values.toList()[index],
                      onChanged: (newValue) {
                        setState(() {
                          //todo.values.toList()[index] = newValue!;
                          todo.update(
                              todo.keys.toList()[index], (value) => newValue!);
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              todo.remove(todo.keys.toList()[index]);
                            });
                            //print(todo);
                          },
                        ),
                        IconButton(
                          color: Colors.black,
                          onPressed: todo.values.toList()[index]
                              ? null
                              : () {
                                  setState(() {
                                    showDialog(
                                      context: context,
                                      builder: ((context) => SimpleDialog(
                                            children: [
                                              TextFormField(
                                                onChanged: ((value) {
                                                  setState(() {
                                                    text = value;
                                                  });
                                                }),
                                                initialValue:
                                                    todo.keys.toList()[index],
                                              ),
                                              ElevatedButton(
                                                  onPressed: (() {
                                                    setState(() {
                                                      todo[text] = false;
                                                      todo.remove(todo.keys
                                                          .toList()[index]);
                                                    });
                                                    Navigator.pop(context);
                                                    //print(todo);
                                                  }),
                                                  child: Text("Güncelle")),
                                            ],
                                          )),
                                    );
                                  });
                                },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
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
                      onPressed: () {
                        setState(() {
                          //todo.add(userInput.text);
                          todo[userInput.text] = false;
                          userInput.clear();
                        });
                        //print(todo);
                      },
                      child: const Text("Ekle"))
                ],
              ),
            )
          ],
        ));
  }
}
