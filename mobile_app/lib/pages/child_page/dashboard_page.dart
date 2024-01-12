// Stateless widget that displays patching data

import 'package:flutter/material.dart';
import 'package:patch_me/models/patch.dart';
import 'package:provider/provider.dart';

import 'dashboard_page/timer_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var patch = Provider.of<Patch>(context);

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
}
