import 'dart:io';

class TodoItem {
  String text;
  bool isChecked;
  File? file;
  TodoItem(this.text, this.isChecked, this.file);

  Map<String, dynamic> toJson() {
    return {"text": text, "isChecked": isChecked, "file": file?.path};
  }

  static TodoItem fromJson(Map<String, dynamic> json) {
    return TodoItem(json["text"], json["isChecked"],
        json["file"] == null ? null : File(json["file"]));
  }
}
