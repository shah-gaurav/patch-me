import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:binding/binding.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'models/app_model.dart';
import 'pages/add_user_page.dart';
import 'pages/home_page.dart';
import 'package:patch_me/pages/user_page/user_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  final appModel = AppModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BindingProvider(
      child: BindingSource<AppModel>(
        instance: appModel,
        initialize: (model) => model.loadUsers(),
        child: MaterialApp(
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: kTextTheme,
              accentColor: Colors.blue,
              bottomAppBarColor: Colors.blue,
              buttonColor: Colors.blue,
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              )),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: kTextTheme,
            accentColor: Colors.blue,
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
