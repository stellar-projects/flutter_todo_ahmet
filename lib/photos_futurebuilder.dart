import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'photos_model.dart';

class PhotoViewFutureBuilder extends StatefulWidget {
  const PhotoViewFutureBuilder({super.key});

  @override
  State<PhotoViewFutureBuilder> createState() => _PhotoViewFutureBuilderState();
}

class _PhotoViewFutureBuilderState extends State<PhotoViewFutureBuilder> {
  late Future<List<PhotosModel>> photos;

  Future<List<PhotosModel>> getApiData() async {
    var dio = Dio();

    var apiKey = "MW6caIG6yo22-AqmbB0186KtLMChtHs3Lj0V8wozNoc";
    var response =
        await dio.get("https://api.unsplash.com/photos/?client_id=$apiKey");

    /*var x =
        await dio.post("https://api.unsplash.com/photos/?client_id=$apiKey",
                  data: 
        );*/

    // jsonDecode == response.data diyebilir miyiz?
    // Çünkü sharedPrefs'de get ile aldığımız veriyi jsonDecode ile anlamlı hale getiriyorduk.
    // Api üzerinden gelen veriyi ise direkt response.data ile anlamlı hale getiriyoruz.

    var parsedJson = response.data;
    if (response.statusCode == 200) {
      if (parsedJson is List) {
        setState(() {});
        return parsedJson.map((e) => PhotosModel.fromJson(e)).toList();
      }
      /*parsedJson.forEach((elm) {
        photos.add(PhotosModel.fromJson(elm));
      });*/
    }
    setState(() {});
    return [];
  }

  @override
  void initState() {
    super.initState();
    /*SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getApiData();
    });*/
    photos = getApiData();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder kullanmanın bir avantajı var mı?
    //Aynı çözümü böyle de elde ettim.

    return Scaffold(
        appBar: AppBar(
          title: const Text("Photos"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<PhotosModel>>(
          future: photos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return Card(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      fit: BoxFit.fill,
                      imageUrl: item.urls?.raw ?? "",
                      height: 200,
                      width: double.infinity,
                      maxHeightDiskCache: 200,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text("Hata Oluştu"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        )

        /*ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: photos.length,
        itemBuilder: (context, index) => Card(
          child: CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            fit: BoxFit.fill,
            imageUrl: photos[index].urls?.raw ?? "",
            height: 200,
            width: double.infinity,
            maxHeightDiskCache: 200,
          ),
        ),
      ),*/
        );
  }
}
