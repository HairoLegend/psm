import 'package:flutter/material.dart';
import 'package:hehe/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automatic Watering System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Dashboard(),
    );
  }
}
