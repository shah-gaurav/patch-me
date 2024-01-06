// Stateless widget that displays patching data

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    return StreamBuilder(
        stream: appState.patchingData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }
          if (snapshot.hasData) {
            var patch = snapshot.data as Patch;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TimerWidget(patch: patch),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.patch,
  });

  final Patch patch;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const TodaysDate(),
            const SizedBox(
              height: 10,
            ),
            ProgressIndicator(patch: patch),
            const SizedBox(
              height: 10,
            ),
            PatchingButton(patch: patch),
          ],
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  final Patch patch;
  const ProgressIndicator({super.key, required this.patch});

  @override
  State<ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
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

class TodaysDate extends StatelessWidget {
  const TodaysDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          ),
        ),
        child: Text(
          DateFormat.yMMMMEEEEd().format(DateTime.now()),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}

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
    patch.timerRunning = true;
    patch.startTime = DateTime.now().millisecondsSinceEpoch;
    patch.timeRemaining = patch.patchTimePerDay - patch.totalTimePatchedToday;
    var appState = context.read<AppState>();
    appState.updatePatchingData(appState.selectedChildRecordKey, patch);
  }

  stopPatching(BuildContext context, Patch patch) async {
    var appState = context.read<AppState>();
    var patchDataForToday = patch.patchDataForToday;
    patchDataForToday.minutes = patch.totalTimePatchedToday;

    patch.timerRunning = false;
    patch.startTime = null;
    patch.timeRemaining = patch.patchTimePerDay - patch.totalTimePatchedToday;
    patch.data = [
      patchDataForToday,
      ...patch.data.where(
          (element) => !DateUtils.isSameDay(element.date, DateTime.now()))
    ];

    await appState.updatePatchingData(appState.selectedChildRecordKey, patch);
  }
}
