import 'package:flutter/material.dart';
import 'package:patch_me/firebase_constants.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/services/auth_service.dart';
import 'package:patch_me/services/child_service.dart';
import 'package:patch_me/services/patch_service.dart';

class AppState extends ChangeNotifier {
  // array of children
  final List<Child> children;
  late String selectedChildRecordKey;
  late Child selectedChild;
  late Patch initialPatchingData;
  late Stream<Patch> patchingDataStream;

  AppState(this.children);

  // add a child to the array
  Future<void> addChild(Child child) async {
    children.add(child);
    await ChildService.storeChildren(children);
    notifyListeners();
  }

  // update a child in the array
  Future<void> updateChild(Child child) async {
    children.removeWhere((element) => element.recordKey == child.recordKey);
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
      await AuthService.signInWithEmailAndPassword(
          email: FirebaseConstants.kFirebaseEmail,
          password: FirebaseConstants.kFirebasePassword);
      var patchDataExists =
          await PatchService.patchingDataExists(child.recordKey);
      if (!patchDataExists) {
        await PatchService.createPatchingData(child.recordKey, child.patchTime);
      }
      selectedChild = child;
      selectedChildRecordKey = child.recordKey;

      // if the timer is running, ensure that it has not been running for more than 2 times the patch time
      initialPatchingData =
          await getPatchingDataAndStopTimerIfUserForgot(child.recordKey);

      patchingDataStream = PatchService.getPatchingDataStream(child.recordKey);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<Patch> getPatchingDataAndStopTimerIfUserForgot(
      String recordKey) async {
    var patchingData = await PatchService.getPatchingData(recordKey);
    if (patchingData.timerRunning == true) {
      var now = DateTime.now();
      var timerStartTime =
          DateTime.fromMillisecondsSinceEpoch(patchingData.startTime!);
      var timeSinceStart = now.difference(timerStartTime);
      var maxTime = Duration(minutes: patchingData.patchTimePerDay * 2);
      if (timeSinceStart > maxTime) {
        patchingData.timerRunning = false;
        patchingData.startTime = null;
        patchingData.timeRemaining = 0;
        var patchDataForTimerStart = patchingData.data.firstWhere(
            (element) => DateUtils.isSameDay(element.date, timerStartTime),
            orElse: () => PatchData(
                  date: timerStartTime,
                  minutes: 0,
                  targetMinutes: patchingData.patchTimePerDay,
                ));
        patchDataForTimerStart.minutes = maxTime.inMinutes;
        patchingData.data = [
          patchDataForTimerStart,
          ...patchingData.data.where(
              (element) => !DateUtils.isSameDay(element.date, timerStartTime))
        ];
        await PatchService.updatePatchingData(recordKey, patchingData);
      }
    }
    return patchingData;
  }

  // unselect selected child
  Future<void> unselectChild() async {
    await AuthService.signOut();
    selectedChildRecordKey = '';
    notifyListeners();
  }

  // update patching data in firestore
  Future<void> updatePatchingData(String recordKey, Patch patch) async {
    await PatchService.updatePatchingData(recordKey, patch);
    notifyListeners();
  }
}
