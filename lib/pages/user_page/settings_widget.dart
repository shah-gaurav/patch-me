import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

enum ConfirmAction { NO, YES }

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = BindingSource.of<UserModel>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Text(
              'Record Key: ${userModel.userId}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
        ],
      ),
    );
  }
}
