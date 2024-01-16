// Stateless widget that displays patching data

import 'package:flutter/material.dart';

import 'dashboard_page/timer_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimerWidget(),
        ],
      ),
    );
  }
}
