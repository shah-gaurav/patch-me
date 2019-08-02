import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import '../../models/app_model.dart';
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
          RaisedButton(
            color: Colors.red[600],
            textColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete),
                Text('REMOVE'),
              ],
            ),
            onPressed: () async {
              if (await _asyncConfirmDialog(context) == ConfirmAction.YES) {
                BindingSource.of<AppModel>(context)
                    .removeUser(id: userModel.userId);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    final userModel = BindingSource.of<UserModel>(context);

    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Confirmation',
            style: Theme.of(context).textTheme.headline,
          ),
          content: Text(
              'Are you sure you want to delete ${userModel.name}\'s record?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.YES);
              },
            )
          ],
        );
      },
    );
  }
}
