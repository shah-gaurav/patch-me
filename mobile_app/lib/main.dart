import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patch_me/pages/add_child.dart';
import 'package:patch_me/pages/homepage.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-child',
      builder: (context, state) => const AddChild(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = getCustomTheme(context);

    return ChangeNotifierProvider(
      create: (context) => AppState(),
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
      scaffoldBackgroundColor: const Color(0xFFF4F27E),
      textTheme: googleFontsTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: googleFontsTheme.labelLarge,
        ),
      ),
    );
    return theme;
  }
}
