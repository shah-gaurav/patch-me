import 'package:auto_size_text/auto_size_text.dart';
import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:random_string/random_string.dart';
import '../models/app_model.dart';

class AddUserPage extends StatefulWidget {
  static const routeName = 'add-user';

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  bool recordKeyReadOnly = true;
  var recordKeyTextEditingController = TextEditingController();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  String _generateRandomKey() {
    return '${randomNumeric(4)}-${randomNumeric(4)}-${randomNumeric(4)}-${randomNumeric(4)}';
  }

  @override
  void initState() {
    super.initState();
    recordKeyTextEditingController.text = _generateRandomKey();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Your Child',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        'No identifiable information about you or your child is stored outside of your device.'),
                    FormBuilder(
                      // context,
                      key: _fbKey,
                      autovalidate: true,
                      initialValue: {
                        'name': 'My Child',
                        'existing_record_key': 1,
                        'patch-time': '120'
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
                          ),
                          FormBuilderTextField(
                            keyboardType: TextInputType.number,
                            attribute: 'patch-time',
                            decoration: InputDecoration(
                                labelText: 'Patch Time (minutes per day)'),
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
                              FormBuilderValidators.max(300),
                            ],
                          ),
                          FormBuilderSegmentedControl(
                            decoration: InputDecoration(
                                labelText: "Do you have a Record Key?"),
                            attribute: "existing_record_key",
                            options: <FormBuilderFieldOption>[
                              FormBuilderFieldOption(
                                value: 1,
                                child: Container(
                                  width: width - 40 / 2,
                                  height: 25,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Center(
                                    child: AutoSizeText('Generae Random'),
                                  ),
                                ),
                              ),
                              FormBuilderFieldOption(
                                value: 2,
                                child: Container(
                                  width: width - 40 / 2,
                                  height: 25,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Center(
                                    child: AutoSizeText('I Have a Record Key'),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value == 1) {
                                  recordKeyReadOnly = true;
                                  recordKeyTextEditingController.text =
                                      _generateRandomKey();
                                } else {
                                  recordKeyReadOnly = false;
                                  recordKeyTextEditingController.text = '';
                                }
                              });
                            },
                          ),
                          Text(
                            'Record Key is used to only track how many minutes the eye is patched everyday.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FormBuilderTextField(
                            controller: recordKeyTextEditingController,
                            attribute: 'record-key',
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            readOnly: recordKeyReadOnly,
                            decoration:
                                InputDecoration(labelText: 'Record Key'),
                            validators: [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.max(15),
                              FormBuilderValidators.min(15),
                              FormBuilderValidators.pattern(
                                  '\\d{4}-\\d{4}-\\d{4}-\\d{4}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        _fbKey.currentState.save();
                        if (_fbKey.currentState.validate()) {
                          print(_fbKey.currentState.value);
                          BindingSource.of<AppModel>(context).addUser(
                            name: _fbKey.currentState.value['name'],
                            id: _fbKey.currentState.value['record-key'],
                            patchTime: int.parse(
                                _fbKey.currentState.value['patch-time']),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
