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
}
