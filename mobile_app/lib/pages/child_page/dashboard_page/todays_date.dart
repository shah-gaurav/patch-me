// Stateless widget that displays patching data

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
