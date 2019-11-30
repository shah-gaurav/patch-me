import 'package:binding/binding.dart';
import 'package:flutter/material.dart';
import '../models/app_model.dart';
import 'add_user_page.dart';
import 'package:patch_me/pages/user_page/user_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = 'home';
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  height: height / 4 > 200 ? 200 : height / 4,
                  width: 200,
                  child: Image.asset('assets/images/patch-me-logo.png'),
                ),
              ),
              Text(
                'Patch Me',
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                'Helping you track your child\'s eye patching time',
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Binding<AppModel>(
                    source: BindingSource.of<AppModel>(context),
                    path: AppModel.usersPropertyName,
                    builder: (_, model) => model.users == null
                        ? Text('loading...')
                        : model.users.length == 0
                            ? Text(
                                'Add your child using the button below to start tracking.',
                                textAlign: TextAlign.center,
                              )
                            : ListView.builder(
                                itemCount: model.users.length,
                                itemBuilder: (_, int index) {
                                  final user = model.users[index];
                                  return InkWell(
                                    onTap: () => Navigator.pushNamed(
                                        context, UserPage.routeName,
                                        arguments: user),
                                    child: Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: Icon(Icons.child_care),
                                        ),
                                        title: Text(user.name),
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(AddUserPage.routeName),
      ),
    );
  }
}
