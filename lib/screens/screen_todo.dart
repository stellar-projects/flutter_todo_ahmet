import 'package:app_todo/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/model_todo.dart';
import '../services/google_services.dart';
import '../todo_bloc/todo_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ScreenTodo extends StatefulWidget {
  const ScreenTodo({super.key});

  @override
  State<ScreenTodo> createState() => _ScreenTodoState();
}

class _ScreenTodoState extends State<ScreenTodo> {
  final FocusNode focusNode = FocusNode();

  List<TodoItem> items = [];

  TextEditingController userInput = TextEditingController();

  String text = "";
  //ImagePicker image = ImagePicker();

  late final SharedPreferences sharedPreferences;

  final TodoBloc _bloc = TodoBloc();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _bloc.close();

    ///Bloclar mutlaka kapatılmalıdır.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.add(EventLoadItems());
    });
  }

  void _handleBlocStates(BuildContext context, state) {
    if (state is StateDidLoadItems) {
      setState(() {
        items = state.items;
      });
    }
  }

  void _goToLoginPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenLogin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ToDo APP"), centerTitle: true),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${user!.displayName}"),
              accountEmail: Text("${user!.email}"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image.network(
                  user!.photoURL ??
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )),
              ),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://w.wallhaven.cc/full/ym/wallhaven-ymlyk7.jpg"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Çıkış Yap"),
              onTap: () {
                signOutWithGoogle().then((value) => _goToLoginPage());
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => const ScreenLogin()));
              },
            ),
          ],
        )),
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
                    return ListTileTodoItem(
                        item: item, bloc: _bloc, index: index);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
              CardTodo(bloc: _bloc, focusNode: focusNode, userInput: userInput)
            ],
          ),
        ));
  }
}

class ListTileTodoItem extends StatelessWidget {
  final TodoItem item;
  final TodoBloc bloc;
  final int index;
  const ListTileTodoItem(
      {Key? key, required this.item, required this.bloc, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.teal, width: 3),
          borderRadius: BorderRadius.circular(20.0)),
      title: Row(
        children: [
          Expanded(
            child: Text(item.text,
                style: TextStyle(
                    decoration:
                        item.isChecked ? TextDecoration.lineThrough : null)),
          ),
          const Spacer(),
          Column(
            children: [
              // Container(
              //   width: 70,
              //   height: 70,
              //   color: Colors.black12,
              //   child: item.file == null
              //       ? const Icon(Icons.image)
              //       : Image.file(
              //           item.file!,
              //           fit: BoxFit.fill,
              //         ),
              // ),
              Row(
                children: [
                  IconButton(
                      iconSize: 20,
                      onPressed: () {
                        bloc.add(EventTakePhotoWithCamera(item));
                      },
                      icon: const Icon(Icons.camera_alt)),
                  IconButton(
                      iconSize: 20,
                      onPressed: () {
                        bloc.add(EventSelectImageFromGallery(item));
                      },
                      icon: const Icon(Icons.photo_library_rounded)),
                ],
              )
            ],
          ),
        ],
      ),
      leading: Checkbox(
        value: item.isChecked,
        onChanged: (newValue) {
          bloc.add(EventCheck(item, newValue ?? false));
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
              bloc.add(EventDeleteItem(index, item.id!));
            },
          ),
          // Builder
          Builder(builder: (updateContext) {
            return IconButton(
              iconSize: 20,
              color: Colors.black,
              onPressed: item.isChecked
                  ? null
                  : () =>
                      bloc.add(EventUpdate(item, updateContext)), // EditPage
              icon: const Icon(Icons.edit),
            );
          }),
        ],
      ),
    );
  }
}

class CardTodo extends StatelessWidget {
  final TodoBloc bloc;
  final FocusNode focusNode;
  final TextEditingController userInput;
  const CardTodo(
      {super.key,
      required this.bloc,
      required this.focusNode,
      required this.userInput});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              onPressed: () async {
                focusNode.unfocus();
                bloc.add(EventAddNewItem(userInput.text));
                userInput.clear();
                print("firebase");

                // await FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
                //     .set({
                //   "note": userInput.text,
                // }, SetOptions(merge: true)).catchError((error, stacktrace) {
                //   print("Firebase eror: $error");
                //   print("stack: $stacktrace");
                // }).then((value) {
                //   print("complete");
                // });
                // print("complete 2");
              },
              child: const Text("Ekle")),
        ],
      ),
    );
  }
}
