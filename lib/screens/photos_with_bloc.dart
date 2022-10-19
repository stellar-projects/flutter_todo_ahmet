import 'package:app_todo/bloc/photo_bloc.dart';
import 'package:app_todo/model/photos_model.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.add(EventGetPhotos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Bloc"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BlocListener(
              bloc: _bloc,
              listener: (context, state) {
                if (state is StateDidReceivePhotos) {
                  setState(() {
                    photos = state.photos.sublist(0, 3);
                  });
                }
              },
              child: photos.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _imageList(photos),
            ),
          ),
          BlocListener(
            bloc: _bloc,
            listener: (context, state) {
              if (state is StateDeletedPhoto) {
                setState(() {
                  photos = state.photos;
                });
              }
            },
            child: ElevatedButton(
              child: const Text("Çıkart"),
              onPressed: () {
                _bloc.add(EventDeletePhoto(photos));
              },
            ),
          )
        ],
      ),
      // body: BlocBuilder(
      //   bloc: _bloc,
      //   builder: (BuildContext context, state) {
      //     if(state is StateDidReceivePhotos){
      //       print("Did receive ohoto: ${state.photos.length}");
      //       return _imageList(state.photos);
      //     }else if(state is StateLoading){
      //       return const Center(child: Text("Loading State"),);
      //     }
      //     return const Center(child: CircularProgressIndicator(),);
      //   },
      //
      // ),
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
