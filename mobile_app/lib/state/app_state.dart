import 'package:flutter/material.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/services/child_service.dart';

class AppState extends ChangeNotifier {
  // array of children
  final List<Child> children;

  AppState(this.children);

  // add a child to the array
  Future<void> addChild(Child child) async {
    children.add(child);
    await ChildService.storeChildren(children);
    notifyListeners();
  }

  // get child from array by recordKey
  Child? getChild(String recordKey) {
    if (recordKey.isEmpty) {
      return null;
    }
    if (children.isEmpty) {
      return null;
    }
    if (children.any((child) => child.recordKey == recordKey)) {
      return children.firstWhere((child) => child.recordKey == recordKey);
    }
    return null;
  }

  // delete child from array by recordKey
  Future<void> deleteChild(String recordKey) async {
    children.removeWhere((child) => child.recordKey == recordKey);
    await ChildService.storeChildren(children);
    notifyListeners();
  }
}
