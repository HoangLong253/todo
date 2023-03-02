import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/verify.dart';

import 'login.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return const Verify();//Menu();
            } else if (!snapshot.hasData) {
              return const Login();
            } else if (snapshot.hasError){
              return const Center(child: Text('Lỗi'),);
            } else {
              return const CircularProgressIndicator();
            }
          }
      )
    );
  }
}
