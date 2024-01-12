import 'package:flutter/material.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class ChildNameDisplay extends StatelessWidget {
  const ChildNameDisplay({super.key, required this.child});
  final Child child;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          child.name,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String editedName = child.name;
                return StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    title: const Text('Edit Child Name'),
                    content: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          editedName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'New Name',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          if (editedName.isNotEmpty) {
                            child.name = editedName;
                            await context
                                .read<AppState>()
                                .updateChild(child)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Child Name Updated',
                                  ),
                                ),
                              );
                            });
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}
