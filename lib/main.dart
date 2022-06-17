import 'package:app_direct/src/home_pg.dart';
import 'package:flutter/material.dart';

/*
Whats app direct
tap tap torch


Unwanted
copy and mark this in task
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        home: const HomePg());
  }
}
