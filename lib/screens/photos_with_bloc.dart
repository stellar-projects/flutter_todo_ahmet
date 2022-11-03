import 'package:app_todo/bloc/photo_bloc.dart';
import 'package:app_todo/model/photos_model.dart';
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

  // var errorName = "";

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
      print("Error");
      // setState(() {
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Bloc"),
      ),
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
