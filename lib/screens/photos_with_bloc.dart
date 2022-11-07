import 'package:app_todo/bloc/photo_bloc.dart';
import 'package:app_todo/services/google_services.dart';
import 'package:app_todo/model/photos_model.dart';
import 'package:app_todo/screens/screen_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenPhotosWithBloc extends StatefulWidget {
  const ScreenPhotosWithBloc({Key? key}) : super(key: key);

  @override
  State<ScreenPhotosWithBloc> createState() => _ScreenPhotosWithBlocState();
}

class _ScreenPhotosWithBlocState extends State<ScreenPhotosWithBloc> {
  final PhotoBloc _bloc = PhotoBloc();

  List<PhotosModel> photos = [];

  final user = FirebaseAuth.instance.currentUser;
  // final navigatorKey = GlobalKey<NavigatorState>();

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
      _bloc.add(EventGetPhotos());
    });
  }

  void _handleBlocStates(BuildContext context, state) {
    if (state is StateDidReceivePhotos) {
      setState(() {
        print("Fotolar Yüklendi");
        photos = state.photos;
      });
    }
    if (state is StatePhotosFailure) {
      debugPrint("HATA: ${state.failure?.description}");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Hata"),
              content: Text(state.failure?.description ?? "<tanımmız>"),
            );
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
      appBar: AppBar(
        title: const Text("Photo Bloc"),
        centerTitle: true,
      ),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BlocListener(
              bloc: _bloc,
              listener: _handleBlocStates,
              child: photos.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _imageList(photos),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageList(List<PhotosModel> photos) => ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          var item = photos[index];
          return Card(
            child: CachedNetworkImage(
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              fit: BoxFit.cover,
              imageUrl: item.urls?.raw ?? "",
              height: 200,
              width: double.infinity,
              maxHeightDiskCache: 200,
            ),
          );
        },
      );
}
