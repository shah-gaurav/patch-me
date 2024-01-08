// Stateless widget that displays patching data

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patch_me/models/patch.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PatchingProgressIndicator extends StatefulWidget {
  final Patch patch;
  const PatchingProgressIndicator({super.key, required this.patch});

  @override
  State<PatchingProgressIndicator> createState() => _PatchingProgressIndicatorState();
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
        center: Column(
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
            ]
          ],
        ),
        progressColor: Colors.green.shade300,
        backgroundColor: Colors.grey.shade300,
      ),
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade400,
    );
  }
}
