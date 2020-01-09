import 'package:binding/binding.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:patch_me/constants.dart';
import 'package:patch_me/models/app_model.dart';
import '../../models/user_model.dart';

enum ConfirmAction { NO, YES }

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var _saveEnabled = false;

  @override
  Widget build(BuildContext context) {
    final userModel = BindingSource.of<UserModel>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: FormBuilder(
              // context,
              key: _fbKey,
              autovalidate: true,
              initialValue: {
                'name': userModel.name,
                'patch-time': userModel.patchTimePerDay.toString(),
                'record-key': userModel.userId
              },
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: 'name',
                    decoration: InputDecoration(labelText: 'Name'),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(15),
                    ],
                    onChanged: (_) {
                      setState(() {
                        _saveEnabled = true;
                      });
                    },
                  ),
                  FormBuilderTextField(
                    keyboardType: TextInputType.number,
                    attribute: 'patch-time',
                    decoration: InputDecoration(
                        labelText: 'Patch Time (minutes per day)'),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(kMaximumPatchTime),
                    ],
                    onChanged: (_) {
                      setState(() {
                        _saveEnabled = true;
                      });
                    },
                  ),
                  FormBuilderTextField(
                    attribute: 'record-key',
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Record Key'),
                    validators: [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(15),
                      FormBuilderValidators.min(15),
                      FormBuilderValidators.pattern(
                          '\\d{4}-\\d{4}-\\d{4}-\\d{4}'),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text("Save"),
                    onPressed: !_saveEnabled ? null : () => _save(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context) {
    _fbKey.currentState.save();
    if (_fbKey.currentState.validate()) {
      BindingSource.of<AppModel>(context).updateUser(
        name: _fbKey.currentState.value['name'],
        id: _fbKey.currentState.value['record-key'],
        patchTime: int.parse(_fbKey.currentState.value['patch-time']),
      );
      Flushbar(
        messageText: Text(
          "Changes saved successfully!",
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.green,
        ),
        duration: Duration(seconds: 5),
        leftBarIndicatorColor: Colors.green,
      )..show(context);
      setState(() {
        _saveEnabled = false;
      });
    }
  }
}
