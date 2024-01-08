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
                  return DailyView(
                      data: data, patch: patch, appState: appState);
                },
              ));
  }
}

class DailyView extends StatelessWidget {
  const DailyView({
    super.key,
    required this.data,
    required this.patch,
    required this.appState,
  });
  final PatchData data;
  final Patch patch;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    var minutesProgress = data.minutes < data.targetMinutes
        ? data.minutes / data.targetMinutes
        : 1.0;
    var color = data.minutes < data.targetMinutes
        ? (minutesProgress < 0.75 ? Colors.red : Colors.green)
        : Colors.green;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
              onPressed: () async {
                // Show dialog that shows the user the patchData minutes and allows them to edit it
                var result = await showEditDialog(context);
                if (result != null) {
                  data.minutes = result;
                  // replace the data in the patch.data list with the new data based on the date
                  patch.data = patch.data
                      .map((e) => e.date == data.date ? data : e)
                      .toList();
                  await appState.updatePatchingData(
                      appState.selectedChildRecordKey, patch);
                }
              },
            )),
      ),
    );
  }

  Future<dynamic> showEditDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var minutes = data.minutes;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Patch Time'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.yMMMEd().format(data.date),
                    style: const TextStyle(
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
