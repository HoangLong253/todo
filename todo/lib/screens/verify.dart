import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool emailVerify = false;
  bool reSendEmail = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailVerify = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!emailVerify) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3),
              (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      emailVerify = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(emailVerify) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => reSendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => reSendEmail = true);
    } catch(e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) => emailVerify
      ? const Menu()//Auth()
      : Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Xác nhận email'),
                const Text('Đã gửi email xác nhận, vui lòng vào email để xác nhận'),
                ElevatedButton(
                    onPressed: reSendEmail ? sendVerificationEmail : null,
                    child: const Text('Gửi xác nhận lại')
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(uid)
                          .delete().then((_) {
                        FirebaseAuth
                            .instance
                            .currentUser!
                            .delete();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Huỷ')
                ),
          ],
        ),
      ),
    ),
  );
}
