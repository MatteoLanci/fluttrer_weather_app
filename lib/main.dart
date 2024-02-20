import 'package:flutter/material.dart';
import 'package:weather_app/pages/test_page.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/themes/themes.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = AppThemes.lightTheme; //default theme

  void _updateTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: _currentTheme,
      // home: WeatherPage(onThemeChange: _updateTheme),
      home: TestPage(),
    );
  }
}
