import 'package:flutter/material.dart';
import 'package:patch_me/models/child.dart';

class AppState extends ChangeNotifier {
  // array of children
  final List<Child> children = [];

  // add a child to the array
  void addChild(Child child) {
    children.add(child);
    notifyListeners();
  }

  AppState() {
    // add a child to the array
    // addChild(Child(name: 'Aamani'));
    // addChild(Child(name: 'Aayushi'));
  }
}
