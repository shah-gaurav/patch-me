import 'package:flutter/material.dart';
import 'package:binding/binding.dart';
import 'package:flutter/services.dart';

import 'models/app_model.dart';
import 'pages/add_user_page.dart';
import 'pages/home_page.dart';
import 'package:patch_me/pages/user_page/user_page.dart';

Future main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appModel = AppModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BindingProvider(
      child: BindingSource<AppModel>(
        instance: appModel,
        initialize: (model) => model.loadUsers(),
        child: MaterialApp(
          theme: ThemeData(
            buttonColor: Colors.green,
            textTheme: TextTheme(
                headline: TextStyle(
                  fontFamily: 'pacifico',
                  fontSize: 30,
                ),
                subhead: TextStyle(
                  fontFamily: 'caveat',
                  fontSize: 22,
                ),
                body1: TextStyle(
                  fontFamily: 'caveat',
                  fontSize: 20,
                ),
                button: TextStyle(
                  fontFamily: 'pacifico',
                  fontSize: 20,
                )),
          ),
          home: HomePage(),
          routes: {
            HomePage.routeName: (_) => HomePage(),
            UserPage.routeName: (_) => UserPage(),
            AddUserPage.routeName: (_) => AddUserPage(),
          },
        ),
      ),
    );
  }
}
