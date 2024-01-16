// Stateless widget that displays patching data

import 'package:flutter/material.dart';
import 'package:patch_me/models/patch.dart';
import 'package:provider/provider.dart';
import 'patching_button.dart';
import 'todays_date.dart';
import 'patching_progress_indicator.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var patch = context.watch<Patch>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const TodaysDate(),
            const SizedBox(
              height: 10,
            ),
            PatchingProgressIndicator(
              patch: patch,
            ),
            const SizedBox(
              height: 10,
            ),
            PatchingButton(
              patch: patch,
            ),
          ],
        ),
      ),
    );
  }
}
