// Stateless widget that displays patching data

import 'package:flutter/material.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class PatchingButton extends StatelessWidget {
  const PatchingButton({
    super.key,
    required this.patch,
  });

  final Patch patch;

  @override
  Widget build(BuildContext context) {
    if (patch.timerRunning == true) {
      return ElevatedButton(
        onPressed: () => stopPatching(context, patch),
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
        child: const Text('Stop Patching'),
      );
    } else {
      return ElevatedButton(
        onPressed: () => startPatching(context, patch),
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.green.shade800),
            ),
        child: const Text('Start Patching'),
      );
    }
  }

  startPatching(BuildContext context, Patch patch) {
    if (patch.totalTimePatchedToday >= patch.patchTimePerDay * 2) {
      // show snackbar that patching time is exceeded for today
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Patching time exceeded for today. Please patch again tomorrow.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    } else {
      patch.timerRunning = true;
      patch.startTime = DateTime.now().millisecondsSinceEpoch;
      patch.timeRemaining = patch.patchTimePerDay - patch.totalTimePatchedToday;
      var appState = context.read<AppState>();
      appState.updatePatchingData(appState.selectedChildRecordKey, patch);
    }
  }

  stopPatching(BuildContext context, Patch patch) async {
    var appState = context.read<AppState>();
    var patchDataForToday = patch.patchDataForToday;
    patchDataForToday.minutes =
        patch.totalTimePatchedToday > patch.patchTimePerDay * 2
            ? patch.patchTimePerDay * 2
            : patch.totalTimePatchedToday;

    patch.timerRunning = false;
    patch.startTime = null;
    patch.timeRemaining = patch.patchTimePerDay - patch.totalTimePatchedToday;
    if (patch.timeRemaining! < 0) patch.timeRemaining = 0;
    patch.data = [
      patchDataForToday,
      ...patch.data.where(
          (element) => !DateUtils.isSameDay(element.date, DateTime.now()))
    ];

    await appState.updatePatchingData(appState.selectedChildRecordKey, patch);
  }
}
