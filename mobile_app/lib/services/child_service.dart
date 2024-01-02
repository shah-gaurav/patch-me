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
    convertOldChildren(prefs);
    final childrenJson = prefs.getString('children');
    if (childrenJson == null) {
      return [];
    }
    final childrenList = jsonDecode(childrenJson) as List;
    return childrenList.map((childJson) => Child.fromJson(childJson)).toList();
  }

  static void convertOldChildren(SharedPreferences prefs) {
    // TODO: Convert old children to new format
  }
}
