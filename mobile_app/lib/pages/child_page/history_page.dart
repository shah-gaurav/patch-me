import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var patch = Provider.of<Patch>(context);
    var appState = context.read<AppState>();
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: patch.data.isEmpty
            ? Center(
                child: Text(
                  'Start patching ${appState.selectedChild.name} by clicking on the Today tab below!',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: patch.data.length,
                itemBuilder: (context, index) {
                  // Implement the itemBuilder function
                  var data = patch.data[index];
                  var minutesProgress = data.minutes < data.targetMinutes
                      ? data.minutes / data.targetMinutes
                      : 1.0;
                  var color = data.minutes < data.targetMinutes
                      ? (minutesProgress < 0.75 ? Colors.red : Colors.green)
                      : Colors.green;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      child: ListTile(
                          leading: CircularPercentIndicator(
                            radius: 28,
                            lineWidth: 8,
                            animation: true,
                            animateFromLastPercent: true,
                            percent: minutesProgress,
                            progressColor: color,
                            center: Text(
                              '${data.minutes}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          title: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            DateFormat.yMMMEd().format(data.date),
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          )),
                    ),
                  );
                },
              ));
  }
}
