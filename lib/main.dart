// ignore_for_file: prefer_const_constructors

import 'package:finance_journal/pages/homepage.dart';
import 'package:finance_journal/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      title: 'FINNACLE',
      theme: ThemeData(
        fontFamily: 'Poppins',
        // scaffoldBackgroundColor: appPrimaryColorSoft,
        primarySwatch: appPrimaryColor,
      ),
      home: HomePage(title: 'F I N N A C L E'),
    );
  }
}
