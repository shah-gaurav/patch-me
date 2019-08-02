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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/patch-me-logo.jpg'),
                ),
              ),
              Text(
                'Patch Me',
                style: Theme.of(context).textTheme.headline,
              ),
              SizedBox(),
              Text(
                'Helping you track your child\'s eye patching time',
                style: Theme.of(context).textTheme.subhead,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: height - 450,
                child: Binding<AppModel>(
                  source: BindingSource.of<AppModel>(context),
                  path: AppModel.usersPropertyName,
                  builder: (_, model) => model.users == null
                      ? Text('loading...')
                      : model.users.length == 0
                          ? Text(
                              'Add your child using the button below to start tracking.')
                          : ListView.builder(
                              itemCount: BindingSource.of<AppModel>(context)
                                  .users
                                  .length,
                              itemBuilder: (_, int index) {
                                final user = BindingSource.of<AppModel>(context)
                                    .users[index];
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
