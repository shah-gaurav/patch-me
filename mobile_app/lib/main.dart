import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patch_me/pages/homepage.dart';
import 'package:patch_me/state/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final googleFontsTheme =
        GoogleFonts.patrickHandTextTheme(textTheme).copyWith(
      headlineLarge: GoogleFonts.pacifico(
        textStyle: textTheme.headlineLarge,
      ),
      labelLarge: GoogleFonts.patrickHandSc(
        textStyle: const TextStyle(
          fontSize: 24,
        ),
      ),
    );

    const colorScheme = ColorScheme.light(
      primary: Color(0xFF3081D0),
      secondary: Color(0xFFFFF5C2),
      tertiary: Color(0xFF6DB9EF),
    );

    var theme = ThemeData(
      colorScheme: colorScheme,
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

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp.router(
        title: 'Patch Me',
        theme: theme,
        routerConfig: _router,
      ),
    );
  }
}
