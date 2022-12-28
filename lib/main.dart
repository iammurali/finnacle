// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/pages/homepage.dart';
import 'package:finance_journal/shared/colors.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FINNACLE',
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.amber,
        primarySwatch: appPrimaryColor,
      ),
      home: HomePage(title: 'F I N N A C L E'),
    );
  }
}
