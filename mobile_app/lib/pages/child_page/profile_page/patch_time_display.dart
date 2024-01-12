import 'package:flutter/material.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/models/patch.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class PatchTimeDisplay extends StatelessWidget {
  const PatchTimeDisplay({
    super.key,
    required this.child,
  });

  final Child child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Patching Time (per day): ${child.patchTime} minutes',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
            onPressed: () async {
              var appState = context.read<AppState>();
              var patch = context.read<Patch>();
              var result = await showEditDialog(context);
              if (result != null) {
                child.patchTime = result;
                patch.patchTimePerDay = result;
                await appState.updatePatchingData(child.recordKey, patch);
                await appState.updateChild(child).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Patching Time Updated',
                      ),
                    ),
                  );
                });
              }
            },
            icon: const Icon(Icons.edit)),
      ],
    );
  }

  Future<dynamic> showEditDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          var minutes = child.patchTime;
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
