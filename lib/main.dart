import 'package:flutter/material.dart';
import 'package:homepage/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pagination Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginState(),
    );
  }
}
