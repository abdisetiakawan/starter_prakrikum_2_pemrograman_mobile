// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

class ShrineApp extends StatefulWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  State<ShrineApp> createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _handleThemeModeChanged(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        // TODO: Change to a Backdrop with a HomePage frontLayer (104)
        '/': (BuildContext context) => HomePage(
              currentThemeMode: _themeMode,
              onThemeModeChanged: _handleThemeModeChanged,
            ),
        // TODO: Make currentCategory field take _currentCategory (104)
        // TODO: Pass _currentCategory for frontLayer (104)
        // TODO: Change backLayer field value to CategoryMenuPage (104)
      },
      theme: ShrineTheme.lightTheme,
      darkTheme: ShrineTheme.darkTheme,
      themeMode: _themeMode,
    );
  }
}

class ShrineTheme {
  ShrineTheme._();

  static final ThemeData lightTheme = _buildLightTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    final ColorScheme colorScheme = _lightColorScheme;
    final ThemeData base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Rubik',
    );
    final TextTheme textTheme = _buildTextTheme(
      base.textTheme,
      _neutralPrimary,
    );
    return base.copyWith(
      scaffoldBackgroundColor: _lightBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        centerTitle: false,
        elevation: 1,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.primary,
          letterSpacing: 0.8,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      cardTheme: base.cardTheme.copyWith(
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        shadowColor: colorScheme.primary.withValues(alpha: 0.2),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colorScheme.primaryContainer,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const StadiumBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 6,
          minimumSize: const Size(120, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(letterSpacing: 0.6),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(letterSpacing: 0.4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          letterSpacing: 0.3,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      iconTheme: base.iconTheme.copyWith(color: colorScheme.primary),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ColorScheme colorScheme = _darkColorScheme;
    final ThemeData base = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Rubik',
      brightness: Brightness.dark,
    );
    final TextTheme textTheme = _buildTextTheme(
      base.textTheme,
      _darkNeutral,
    );
    return base.copyWith(
      scaffoldBackgroundColor: _darkBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          letterSpacing: 0.8,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        clipBehavior: Clip.antiAlias,
        color: colorScheme.surface,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.45),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          minimumSize: const Size(120, 48),
          elevation: 4,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(letterSpacing: 0.6),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(letterSpacing: 0.4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          letterSpacing: 0.3,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.45),
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      iconTheme: base.iconTheme.copyWith(color: colorScheme.primary),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color color) {
    return base
        .copyWith(
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 16,
            letterSpacing: 0.2,
          ),
          bodySmall: base.bodySmall?.copyWith(
            letterSpacing: 0.3,
          ),
          labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          labelSmall: base.labelSmall?.copyWith(
            letterSpacing: 0.4,
          ),
        )
        .apply(
          bodyColor: color,
          displayColor: color,
        );
  }
}

const Color _lightBackground = Color(0xFFF4F6FB);
const Color _darkBackground = Color(0xFF121620);
const Color _neutralPrimary = Color(0xFF102A43);
const Color _darkNeutral = Color(0xFFE6EDF7);

final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF1B4965),
  brightness: Brightness.light,
  surface: Colors.white,
  tertiary: const Color(0xFF588157),
  secondary: const Color(0xFFF26419),
);

final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF5FA8D3),
  brightness: Brightness.dark,
  surface: const Color(0xFF1A1F2B),
  tertiary: const Color(0xFF82C0CC),
  secondary: const Color(0xFFFFA45B),
);
