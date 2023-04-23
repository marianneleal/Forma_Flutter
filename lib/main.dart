import 'package:flutter/material.dart';
import 'package:forma_flutter/screens/home.dart';

void main() {
  runApp(const FormaApp());
}

class FormaApp extends StatelessWidget {
  const FormaApp({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Forma App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const Home());
  }
}
