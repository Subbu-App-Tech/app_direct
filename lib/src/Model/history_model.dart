
import 'dart:convert';

class StorageClipModel {
  String text;
  String mobileNo;
  int index;
  late String key;
  late DateTime date;
  StorageClipModel(
      {required this.text, required this.mobileNo, this.index = 100}) {
    date = DateTime.now();
    key = date.microsecondsSinceEpoch.toString();
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'text': text});
    result.addAll({'mobileNo': mobileNo});
    result.addAll({'index': index});
    result.addAll({'date': date.millisecondsSinceEpoch});
    return result;
  }

  factory StorageClipModel.fromMap(Map<String, dynamic> map, String key) {
    final stg = StorageClipModel(
        text: map['text'] ?? '',
        mobileNo: map['mobileNo'] ?? '',
        index: map['index'] ?? 100);
    stg.date = DateTime.fromMillisecondsSinceEpoch(map['date']);
    stg.key = key;
    return stg;
  }

  String toJson() => json.encode(toMap());

  factory StorageClipModel.fromJson(String source, String key) =>
      StorageClipModel.fromMap(json.decode(source), key);
}
