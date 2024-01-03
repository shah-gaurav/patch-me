import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  final _formKey = GlobalKey<FormBuilderState>();

  String _generateRandomKey() {
    return '${randomNumeric(4)}-${randomNumeric(4)}-${randomNumeric(4)}-${randomNumeric(4)}';
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Your Child'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                initialValue: {
                  'name': 'My Child',
                  'patchTime': '60',
                  'recordKey': _generateRandomKey(),
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'name',
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: FormBuilderValidators.required(),
                        ),
                        FormBuilderTextField(
                          name: 'patchTime',
                          decoration: const InputDecoration(
                              labelText: 'Patch Time (minutes per day)'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                            FormBuilderValidators.min(0),
                            FormBuilderValidators.max(1440),
                          ]),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Record Key',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text(
                          'Record Key is only used to track how many minutes the eye patch is worn. It is not used to identify your child or you.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        FormBuilderSwitch(
                          name: 'existingRecordKey',
                          title: Text(
                            'I have already setup my child on another device and have a record key',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          onChanged: (value) {
                            if (value != null && value) {
                              _formKey.currentState?.fields['recordKey']
                                  ?.didChange('');
                            } else {
                              var recordKey = _generateRandomKey();
                              _formKey.currentState?.fields['recordKey']
                                  ?.didChange(recordKey);
                            }
                          },
                        ),
                        FormBuilderTextField(
                            name: 'recordKey',
                            decoration:
                                const InputDecoration(labelText: 'Record Key'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(19),
                              FormBuilderValidators.maxLength(19),
                              FormBuilderValidators.match(
                                  '\\d{4}-\\d{4}-\\d{4}-\\d{4}')
                            ]),
                            keyboardType: TextInputType.phone),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Validate and save the form values
                            _formKey.currentState?.saveAndValidate();
                            await appState.addChild(Child(
                              name: _formKey.currentState?.value['name'],
                              patchTime: int.parse(
                                  _formKey.currentState?.value['patchTime']),
                              recordKey:
                                  _formKey.currentState?.value['recordKey'],
                            ));
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          child: const Text('Add Child'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'We are parents as well and understand the importance of protecting your child\'s privacy. No identifying information about you or your child is stored outside of your device.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
