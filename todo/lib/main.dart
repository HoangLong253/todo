import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/auth.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.€
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //restorationScopeId: "root",
      debugShowCheckedModeBanner: false,
      title: 'To-do App',
      home: Auth(), //Add(),
    );
  }
}
