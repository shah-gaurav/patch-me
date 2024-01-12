import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patch_me/models/child.dart';

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
          style: Theme.of(context).textTheme.bodyLarge,
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
