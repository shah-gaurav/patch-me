import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'profile_page/child_name_display.dart';
import 'profile_page/patch_time_display.dart';
import 'profile_page/record_key_display.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var child = appState.selectedChild;
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Profile Information',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                ChildNameDisplay(child: child),
                const SizedBox(
                  height: 20,
                ),
                RecordKeyDisplay(child: child),
                PatchTimeDisplay(child: child),
                const SizedBox(
                  height: 20,
                ),
                GenerateReportButton(child: child),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
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
                  label: const Text('Delete'),
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

class GenerateReportButton extends StatelessWidget {
  const GenerateReportButton({
    super.key,
    required this.child,
  });

  final Child child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: const Icon(Icons.bar_chart),
        onPressed: () async {
          final url =
              Uri.parse('https://patchme.app/report?id=${child.recordKey}');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            // show snackbar with error
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Could not launch URL $url in the browser',
                  ),
                ),
              );
            }
          }
        },
        label: const Text('Generate Report'));
  }
}
