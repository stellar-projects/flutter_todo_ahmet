/// text : "test"
/// isChecked : true

class ModelTodo {
  ModelTodo({
      this.text, 
      this.isChecked,});

  ModelTodo.fromJson(dynamic json) {
    text = json['text'];
    isChecked = json['isChecked'];
  }
  String? text;
  bool? isChecked;
ModelTodo copyWith({  String? text,
  bool? isChecked,
}) => ModelTodo(  text: text ?? this.text,
  isChecked: isChecked ?? this.isChecked,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = text;
    map['isChecked'] = isChecked;
    return map;
  }

}