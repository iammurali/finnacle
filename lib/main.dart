// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/pages/homepage.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance journal',
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.amber,
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'F I N N A C L E'),
    );
  }
}
