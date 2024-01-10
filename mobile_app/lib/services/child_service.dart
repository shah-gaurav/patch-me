import 'dart:convert';
import 'package:patch_me/models/child.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildService {
  static Future<void> storeChildren(List<Child> children) async {
    final prefs = await SharedPreferences.getInstance();
    final childrenJson =
        jsonEncode(children.map((child) => child.toJson()).toList());
    prefs.setString('children', childrenJson);
  }

  static Future<List<Child>> retrieveChildren() async {
    final prefs = await SharedPreferences.getInstance();
    await convertOldChildren(prefs);
    final childrenJson = prefs.getString('children');
    if (childrenJson == null) {
      return [];
    }
    final childrenList = jsonDecode(childrenJson) as List;
    return childrenList.map((childJson) => Child.fromJson(childJson)).toList();
  }

  static Future<void> convertOldChildren(SharedPreferences prefs) async {
    if (prefs.containsKey('users')) {
      final users = prefs.getStringList('users');
      if (users == null) return;
      final List<Child> children = [];
      for (var item in users) {
        var values = item.split('***');
        children.add(Child(
            name: values[0],
            recordKey: values[1],
            patchTime: int.parse(values[2])));
      }
      await storeChildren(children);
      await prefs.remove('users');
    }
  }
}
