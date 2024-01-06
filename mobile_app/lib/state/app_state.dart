import 'package:flutter/material.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/services/child_service.dart';
import 'package:patch_me/services/patch_service.dart';

class AppState extends ChangeNotifier {
  // array of children
  final List<Child> children;
  late String selectedChildRecordKey;
  late Child selectedChild;
  late Stream<Patch> patchingData;

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

  // select child from array by recordKey
  Future<bool> selectChild(String recordKey) async {
    var child = getChild(recordKey);
    if (child != null) {
      var patchDataExists =
          await PatchService.patchingDataExists(child.recordKey);
      if (!patchDataExists) {
        await PatchService.createPatchingData(child.recordKey, child.patchTime);
      }
      selectedChild = child;
      selectedChildRecordKey = child.recordKey;
      patchingData = PatchService.getPatchingDataStream(child.recordKey);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // update patching data in firestore
  Future<void> updatePatchingData(String recordKey, Patch patch) async {
    await PatchService.updatePatchingData(recordKey, patch);
    notifyListeners();
  }
}
