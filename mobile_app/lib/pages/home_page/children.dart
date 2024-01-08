import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

class Children extends StatelessWidget {
  const Children({
    super.key,
    required this.appState,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    var appState = context.read<AppState>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          itemCount: appState.children.length,
          itemBuilder: (context, index) {
            var child = appState.children[index];
            return Card(
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.secondary,
                leading: const Icon(Icons.child_care),
                title: Text(child.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  var childSelected =
                      await appState.selectChild(child.recordKey);
                  if (childSelected && context.mounted) {
                    context.push('/child/${child.recordKey}');
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
