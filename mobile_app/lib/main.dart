import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patch_me/models/child.dart';
import 'package:patch_me/pages/add_child_page.dart';
import 'package:patch_me/pages/child_page.dart';
import 'package:patch_me/pages/home_page.dart';
import 'package:patch_me/services/child_service.dart';
import 'package:patch_me/services/messaging_service.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeFirebase();

  var children = await ChildService.retrieveChildren();

  await GoogleFonts.pendingFonts([
    GoogleFonts.patrickHand(),
    GoogleFonts.patrickHandSc(),
    GoogleFonts.pacifico(),
  ]);

  runApp(MyApp(
    children: children,
  ));
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // use local emulator if in debug mode
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // listen for firebase messaging notifications and show a dialog if the app is in the foreground
  MessagingService.initializeNotifications(pushNotificationAlert);
}

pushNotificationAlert() async {
  showDialog(
    context: _router.routerDelegate.navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: const Text('Patching almost complete'),
      content: const Text(
          'Please make sure to take off the patch and stop the timer.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

final _router = GoRouter(
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-child',
      builder: (context, state) => const AddChildPage(),
    ),
    GoRoute(
      path: '/child/:recordKey',
      builder: (context, state) {
        return ChildPage(recordKey: state.pathParameters['recordKey']!);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.children,
  });

  final List<Child> children;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = getCustomTheme(context);

    return ChangeNotifierProvider(
      create: (context) => AppState(children),
      child: MaterialApp.router(
        title: 'Patch Me',
        theme: theme,
        routerConfig: _router,
      ),
    );
  }

  ThemeData getCustomTheme(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final googleFontsTheme =
        GoogleFonts.patrickHandTextTheme(textTheme).copyWith(
      headlineLarge: GoogleFonts.pacifico(
        textStyle: textTheme.headlineLarge,
      ),
      headlineMedium: GoogleFonts.pacifico(
        textStyle: textTheme.headlineMedium,
      ),
      labelLarge: GoogleFonts.patrickHandSc(
        textStyle: const TextStyle(
          fontSize: 24,
        ),
      ),
    );

    const colorScheme = ColorScheme.light(
      primary: Color(0xFF519259),
      secondary: Color(0xFFFFF5C2),
      tertiary: Color(0xFF6DB9EF),
    );

    var theme = ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF064635),
        foregroundColor: colorScheme.onPrimary,
      ),
      cardTheme: CardTheme(
        color: colorScheme.secondary,
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F27E),
      textTheme: googleFontsTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: googleFontsTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF519259),
        selectedItemColor: colorScheme.onPrimary,
        unselectedItemColor: colorScheme.onPrimary.withOpacity(0.7),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.tertiary,
        contentTextStyle: googleFontsTheme.bodyLarge,
      ),
    );
    return theme;
  }
}
