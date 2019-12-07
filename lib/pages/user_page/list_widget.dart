import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:patch_me/models/patch_time_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../models/user_model.dart';

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    final userModel = BindingSource.of<UserModel>(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxWidth: 500),
        child: ListView.builder(
          itemCount: userModel.data.length,
          itemBuilder: (_, index) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getBackgroundColor(userModel.data[index]),
                child: Text(
                  userModel.data[index].minutes.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                DateFormat.yMMMMEEEEd().format(userModel.data[index].date),
                style: Theme.of(context).textTheme.body1,
              ),
              trailing: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showModalDialog(context, userModel.data[index]);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(PatchTimeModel data) {
    final patchPercent = data.minutes / data.targetMinutes;
    if (patchPercent < 0.5)
      return Colors.red;
    else if (patchPercent >= 0.5 && patchPercent < 0.75)
      return Colors.yellow[600];
    else
      return Colors.green;
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  _showModalDialog(BuildContext context, PatchTimeModel data) {
    Alert(
      style: AlertStyle(
          titleStyle:
              TextStyle(color: Theme.of(context).textTheme.title.color)),
      context: context,
      title: 'Patch Time',
      content: Column(
        children: <Widget>[
          Text(
            DateFormat.yMMMMEEEEd().format(data.date),
            style: Theme.of(context).textTheme.subhead,
          ),
          FormBuilder(
            key: _fbKey,
            autovalidate: true,
            child: FormBuilderTextField(
              initialValue: data.minutes.toString(),
              keyboardType: TextInputType.number,
              attribute: 'patch-time',
              decoration: InputDecoration(labelText: 'Patch Time (in minutes)'),
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
                FormBuilderValidators.max(300),
              ],
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () async {
            _fbKey.currentState.save();
            if (_fbKey.currentState.validate()) {
              if (int.parse(_fbKey.currentState.value['patch-time']) !=
                  data.minutes) {
                await BindingSource.of<UserModel>(context).updatePatchTime(
                  date: data.date,
                  patchTime: int.parse(_fbKey.currentState.value['patch-time']),
                );
              }
              Navigator.of(context).pop();
            }
          },
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
      closeFunction: () {},
    ).show();
  }
}
