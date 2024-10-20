import 'package:app/class.dart';
import 'package:app/data.dart';
import 'package:app/firebase_options.dart';
import 'package:app/homepage.dart';

import 'package:app/login.dart';
import 'package:app/otp_screen.dart';
import 'package:app/phone_auth.dart';
import 'package:app/signup.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        // themeMode: ThemeMode.dark,
        home: ClassWork());
  }
}
