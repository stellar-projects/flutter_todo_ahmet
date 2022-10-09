class PhotosModel {
  String? id;
  String? createdAt;
  String? color;
  //Map<String, dynamic>? urls;
  Urls? urls;

  PhotosModel({this.id, this.createdAt, this.color, this.urls});

  PhotosModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    createdAt = json["created_at"];
    color = json["color"];
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
  }
}

class Urls {
  String? raw;
  String? full;
  String? regular;
  String? small;
  String? thumb;
  String? smallS3;

  Urls(
      {this.raw,
      this.full,
      this.regular,
      this.small,
      this.thumb,
      this.smallS3});

  Urls.fromJson(Map<String, dynamic> json) {
    raw = json['raw'];
    full = json['full'];
    regular = json['regular'];
    small = json['small'];
    thumb = json['thumb'];
    smallS3 = json['small_s3'];
  }
}
