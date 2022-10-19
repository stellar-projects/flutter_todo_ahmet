import 'package:app_todo/model/photos_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class PhotoView extends StatefulWidget {
  const PhotoView({super.key});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  List<PhotosModel> photos = [];

  void getApiData() async {
    var dio = Dio();

    var apiKey = "MW6caIG6yo22-AqmbB0186KtLMChtHs3Lj0V8wozNoc";
    var response =
        await dio.get("https://api.unsplash.com/photos/?client_id=$apiKey");

    // jsonDecode == response.data diyebilir miyiz?
    // Çünkü sharedPrefs'de get ile aldığımız veriyi jsonDecode ile anlamlı hale getiriyorduk.
    // Api üzerinden gelen veriyi ise direkt response.data ile anlamlı hale getiriyoruz.

    var parsedJson = response.data;
    if (response.statusCode == 200) {
      if (parsedJson is List) {
        photos = parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
      }

      /*parsedJson.forEach((elm) {
        photos.add(PhotosModel.fromJson(elm));
      });*/

    }

    setState(() {});
    //print(parsedJson.runtimeType);
    //print(response.runtimeType); -> response

    //print(parsedJson[0].runtimeType);
    //var x = PhotosModel.fromJson(parsedJson[0]); // _internalLinkedHasMap <String, dynamic>
    //print(x.runtimeType); // PhotosModel
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getApiData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photos"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          /*var item = photos[index];
          print(item.id);*/
          return Card(
            child: CachedNetworkImage(
              placeholder: (context, url) => const CircularProgressIndicator(),
              fit: BoxFit.fill,
              imageUrl: photos[index].urls?.raw ?? "", //item.urls?.raw ?? "",
              height: 200,
              width: double.infinity,
              maxHeightDiskCache: 200,
            ),
          );
        },
      ),
    );
  }
}
