import 'package:app_direct/src/Model/history_model.dart';
export 'package:app_direct/src/Model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Storage storage = Storage();

class Storage with ChangeNotifier {
  SharedPreferences? _db;
  SharedPreferences get db => _db!;
  static final Storage _singleton = Storage._internal();
  factory Storage() => _singleton;
  Storage._internal();

  Future init() async {
    _db = await SharedPreferences.getInstance();
    _loadtextStored();
    _getIndex();
  }

  Future saveClipText(StorageClipModel model) async {
    if (_data.length >= 30) {
      await db.remove(keySortedList.last);
      keySortedList.removeLast();
    }
    keySortedList.insert(0, model.key);
    await db.setString(model.key, model.toJson());
    _updateKeyIndex();
    _data.add(model);
    notifyListeners();
  }

  Future deleteClip(StorageClipModel model) async {
    await db.remove(model.key);
    keySortedList.remove(model.key);
    _data.removeWhere((e) => e.key == model.key);
    _updateKeyIndex();

    notifyListeners();
  }

  int get length => db.getKeys().length;
  List<StorageClipModel> _data = [];
  List<StorageClipModel> get data =>
      keySortedList.map((e) => _data.firstWhere((d) => d.key == e)).toList();

  bool isExist(String text) {
    int iidx = _data.indexWhere((e) => e.text == text);
    return iidx != -1;
  }

  List<StorageClipModel> _loadtextStored() {
    final keys = db.getKeys().toList();
    _data = [];
    keys.remove('indexList');
    for (var e in keys) {
      final bb = db.getString(e);
      if (bb != null) _data.add(StorageClipModel.fromJson(bb, e));
    }
    return _data.sortedData(keySortedList);
  }

  List<String> keySortedList = [];
  List<String> _getIndex() {
    keySortedList = db.getStringList('indexList') ?? [];
    return keySortedList;
  }

  void changeInIndex(int oldIdx, int newIdx) {
    final oldKey = keySortedList.elementAt(oldIdx);
    keySortedList.removeAt(oldIdx);
    if (newIdx > keySortedList.length) {
      keySortedList.add(oldKey);
    } else {
      keySortedList.insert(newIdx, oldKey);
    }
    _updateKeyIndex();
  }

  void _updateKeyIndex() async {
    await db.setStringList('indexList', keySortedList);
  }
}

extension StorageClipModelListExo on List<StorageClipModel> {
  List<StorageClipModel> sortedData(List<String> keySortedList) {
    sort((b, a) => a.date.compareTo(b.date));
    sort((a, b) => a.index.compareTo(b.index));
    return this;
  }
}
