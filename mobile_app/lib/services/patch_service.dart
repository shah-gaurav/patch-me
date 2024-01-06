import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patch_me/models/patch.dart';

class PatchService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  // check if patching data exists by recordKey
  static Future<bool> patchingDataExists(String recordKey) async {
    final ref = db.collection('users').doc(recordKey);
    final doc = await ref.get();
    return doc.exists;
  }

  // create patching data by recordKey
  static Future<void> createPatchingData(
      String recordKey, int patchTimePerDay) async {
    final ref = db
        .collection('users')
        .withConverter<Patch>(
          fromFirestore: (snapshot, _) => Patch.fromJson(snapshot.data()!),
          toFirestore: (patch, _) => patch.toJson(),
        )
        .doc(recordKey);

    await ref.set(Patch(patchTimePerDay: patchTimePerDay));
  }

  // get patching data by recordKey
  static Stream<Patch> getPatchingDataStream(String recordKey) {
    final ref = db
        .collection('users')
        .withConverter<Patch>(
          fromFirestore: (snapshot, _) => Patch.fromJson(snapshot.data()!),
          toFirestore: (patch, _) => patch.toJson(),
        )
        .doc(recordKey);

    return ref
        .snapshots()
        .map((snapshot) => snapshot.data() ?? Patch(patchTimePerDay: 120));
  }

  // update patching data by recordKey
  static Future<void> updatePatchingData(String recordKey, Patch patch) async {
    final ref = db
        .collection('users')
        .withConverter<Patch>(
          fromFirestore: (snapshot, _) => Patch.fromJson(snapshot.data()!),
          toFirestore: (patch, _) => patch.toJson(),
        )
        .doc(recordKey);

    await ref.set(patch);
  }
}
