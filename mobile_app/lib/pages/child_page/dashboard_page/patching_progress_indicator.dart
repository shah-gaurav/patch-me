// Stateless widget that displays patching data

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class PatchingProgressIndicator extends StatefulWidget {
  final Patch patch;
  const PatchingProgressIndicator({super.key, required this.patch});

  @override
  State<PatchingProgressIndicator> createState() =>
      _PatchingProgressIndicatorState();
}

class _PatchingProgressIndicatorState extends State<PatchingProgressIndicator> {
  Timer? timer;

  double secondsProgress = 0;
  double minutesProgress = 0;
  int minutesRemaining = 0;

  @override
  void initState() {
    updateState();
    super.initState();
  }

  void resetState() {
    if (!mounted) {
      timer?.cancel();
      timer = null;
      return;
    }

    setState(() {
      secondsProgress = 0;
    });
  }

  void updateState() {
    if (!mounted) {
      timer?.cancel();
      timer = null;
      return;
    }

    setState(() {
      var secondsInMinutes = widget.patch.secondsSinceTimerStarted / 60;
      secondsProgress = secondsInMinutes - secondsInMinutes.floor();
      if (widget.patch.totalTimePatchedToday < widget.patch.patchTimePerDay) {
        minutesProgress =
            widget.patch.totalTimePatchedToday / widget.patch.patchTimePerDay;
      } else {
        minutesProgress = 1.0;
      }
      minutesRemaining =
          widget.patch.patchTimePerDay - widget.patch.totalTimePatchedToday;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.patch.timerRunning == true) {
      timer = Timer(const Duration(seconds: 1), () {
        updateState();
      });
    } else {
      resetState();
      timer?.cancel();
      timer = null;
    }
    return CircularPercentIndicator(
      radius: 120,
      lineWidth: 20.0,
      animation: true,
      animateFromLastPercent: true,
      percent: minutesProgress,
      center: CircularPercentIndicator(
        radius: 100,
        lineWidth: 10.0,
        percent: secondsProgress,
        center: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (minutesRemaining < 0) ...[
                Text(
                  'Over by',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${minutesRemaining.abs()} minutes',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ] else ...[
                Text(
                  '$minutesRemaining minutes',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'Remaining',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
              IconButton(
                onPressed: widget.patch.timerRunning == true
                    ? null
                    : () async {
                        var appState = context.read<AppState>();
                        var patch = widget.patch;
                        var result = await showEditDialog(
                            context, patch.totalTimePatchedToday);
                        if (result != null) {
                          var patchDataForToday = patch.patchDataForToday;
                          patchDataForToday.minutes = result;
                          patch.data = [
                            patchDataForToday,
                            ...patch.data.where((element) =>
                                !DateUtils.isSameDay(
                                    element.date, DateTime.now()))
                          ];
                          await appState.updatePatchingData(
                              appState.selectedChildRecordKey, patch);
                          updateState();
                        }
                      },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
        progressColor: Colors.green.shade300,
        backgroundColor: Colors.grey.shade300,
      ),
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade400,
    );
  }

  Future<dynamic> showEditDialog(BuildContext context, int initialMinutes) {
    return showDialog(
        context: context,
        builder: (context) {
          var minutes = initialMinutes;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Patching Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Minutes Per Day',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (minutes > 0) {
                            setState(() => minutes--);
                          }
                        },
                      ),
                      Text(
                        '$minutes',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => minutes++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(minutes);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }
}
