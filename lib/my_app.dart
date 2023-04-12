import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lime,
        brightness:  Brightness.dark,
      ),
      home: const HomePage(title: 'Tic-Tac-Toe'),
    );
  }
}
