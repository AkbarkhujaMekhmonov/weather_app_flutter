import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/pages/home_page.dart';
import 'package:weather/utills/colors.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: true,colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true,colorScheme: darkColorScheme),
      home: const HomePage(),
    );
  }
}
