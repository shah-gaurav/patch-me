import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final String childRecordKey;

  const ProfilePage({super.key, required this.childRecordKey});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var child = appState.getChild(childRecordKey);
    if (child == null) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Profile for ${child.name}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                RecordKeyDisplay(child: child),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Patching Time (per day): ${child.patchTime} minutes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // ask user for confirmation
                    bool? result = await deleteConfirmation(context);

                    if (result == true) {
                      await appState.deleteChild(child.recordKey);

                      if (context.mounted) {
                        // show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(                            
                            content: Text(
                              'Child Profile Deleted from Device',
                            ),
                          ),
                        );
                        context.pop();
                      }
                    }
                  },
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> deleteConfirmation(BuildContext context) async {
    var result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Child Profile'),
          content: const Text(
              'Are you sure you want to delete this child profile from your device? You will not be able to recover it later without the record key.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    return result;
  }
}

class RecordKeyDisplay extends StatelessWidget {
  const RecordKeyDisplay({
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
          child.recordKey,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          iconSize: 16,
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: child.recordKey),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Record Key copied to clipboard',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
