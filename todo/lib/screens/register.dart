import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/components/provider.dart';
import 'package:todo/screens/login.dart';

import '../models/user.dart';
import 'auth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController txtMail1 = TextEditingController();
  TextEditingController txtPass1 = TextEditingController();
  TextEditingController txtCf = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  List<User1> alluser = [];
  String? check = '';

  bool smth = false;
  bool cpass = true;
  bool ccf = true;
  bool change = false;
  bool checkUser = false;
  bool checkEmail = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  fetch() async {
    var records = await FirebaseFirestore.instance.collection('users').get();
    getAllUser(records);
  }

  getAllUser(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map((e) => User1(
              username: e['username'],
              email: e['email'],
            ))
        .toList();
    alluser = list;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }

  Future regwconfirm() async {
    String temp1 = txtMail1.text;
    String temp2 = txtUsername.text;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: txtMail1.text,
        password: txtPass1.text,
      )
          .then((value) {
        final user = User1(
          uid: FirebaseAuth.instance.currentUser?.uid,
          email: temp1,
          username: temp2,
        );
        createUser(user, value.user!.uid);
      });
      User? us = FirebaseAuth.instance.currentUser;
      us!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future rg() async {
    String uid = 'lhkjhkhh';
    final user = User1(
      username: txtUsername.text.trim(),
      email: txtMail1.text.trim(),
    );
    createUser(user, uid);
  }

  @override
  void dispose() {
    txtUsername.dispose();
    txtPass1.dispose();
    txtMail1.dispose();
    txtCf.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future register() async {
      String temp1 = txtMail1.text;
      String temp2 = txtUsername.text;
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: txtMail1.text.trim(),
          password: txtPass1.text.trim(),
        )
            .then((value) {
          final user = User1(
            uid: FirebaseAuth.instance.currentUser?.uid,
            email: temp1,
            username: temp2,
          );
          createUser(user, value.user!.uid);
        });
      } /*on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            {
              ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                  const SnackBar(content: Text('Email ???? ???????c s??? d???ng')));
              break;
            }
          case 'invalid-email':
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email kh??ng h???p l???')));
              break;
            }
          case 'weak-password':
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('M???t kh???u kh??ng ????? 8 k?? t???')));
              break;
            }
        }
      }*/
      catch (e) {
        return e;
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Image.asset('assets/imgs/todo.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '????ng k??',
                style: TextStyle(fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Username:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    color: Colors.white,
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            checkUser = false;
                          });
                        },
                        controller: txtUsername,
                        obscureText: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue)),
                            border: OutlineInputBorder(),
                            hintText: 'Nh???p username',
                            hintStyle: TextStyle(color: Colors.grey))),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    color: Colors.white,
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            checkEmail = false;
                          });
                        },
                        controller: txtMail1,
                        obscureText: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue)),
                            border: OutlineInputBorder(),
                            hintText: 'Nh???p email',
                            hintStyle: TextStyle(color: Colors.grey))),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    color: Colors.white,
                    child: TextField(
                        controller: txtPass1,
                        obscureText: cpass,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cpass = !cpass;
                                });
                              },
                              child: Icon(cpass
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue)),
                            border: const OutlineInputBorder(),
                            hintText: 'Nh???p m???t kh???u',
                            hintStyle: const TextStyle(color: Colors.grey))),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'X??c nh???n password:',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    color: Colors.white,
                    child: TextField(
                        controller: txtCf,
                        obscureText: ccf,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  ccf = !ccf;
                                });
                              },
                              child: Icon(ccf
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.blue)),
                            border: const OutlineInputBorder(),
                            hintText: 'Nh???p l???i password',
                            hintStyle: const TextStyle(color: Colors.grey))),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: change,
                      onChanged: (value) {
                        setState(() {
                          change = value!;
                        });
                      }),
                  const Text('T??i ?????ng ?? v???i c??c ??i???u kho???n')
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    for (var list in alluser) {
                      if (list.username.toString() == txtUsername.text) {
                        setState(() {
                          checkUser = true;
                        });
                        break;
                      }
                      if (list.email.toString() == txtMail1.text) {
                        setState(() {
                          checkEmail = true;
                        });
                        break;
                      }
                    }
                    if (txtUsername.text.isEmpty ||
                        txtMail1.text.isEmpty ||
                        txtPass1.text.isEmpty ||
                        txtCf.text.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Vui l??ng nh???p ?????y ????? c??c tr?????ng d??? li???u')));
                    } else if (txtPass1.text.length < 8) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Password kh??ng tr??n 8 k?? t???')));
                      txtUsername.text = '';
                      txtMail1.text = '';
                      txtPass1.text = '';
                      txtCf.text = '';
                    } else if (txtPass1.text != txtCf.text) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Password kh??ng tr??ng kh???p')));
                    } else if (change == false) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Vui l??ng tick v??o ?? x??c nh???n')));
                      txtUsername.text = '';
                      txtMail1.text = '';
                      txtPass1.text = '';
                      txtCf.text = '';
                    } else if (checkUser) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Username ???? ???????c d??ng')));
                      txtUsername.text = '';
                      txtMail1.text = '';
                      txtPass1.text = '';
                      txtCf.text = '';
                    } else if (checkEmail) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email ???? ???????c d??ng')));
                      txtUsername.text = '';
                      txtMail1.text = '';
                      txtPass1.text = '';
                      txtCf.text = '';
                    } else {
                      register();
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Auth()),
                              (route) => route.isCurrent)
                          .then((value) {
                        if (FirebaseAuth.instance.currentUser != null) {
                          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                              .showSnackBar(const SnackBar(
                                  content: Text('????ng k?? th??nh c??ng')));
                        }
                      });

                      txtUsername.text = '';
                      txtMail1.text = '';
                      txtPass1.text = '';
                      txtCf.text = '';
                      //signOut();
                    }
                  },
                  child: const Text(
                    '????ng k??',
                    style: TextStyle(color: Colors.white),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('???? c?? t??i kho???n, '),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false);
                      },
                      child: const Text(
                        '????ng nh???p ngay',
                        style: TextStyle(color: Colors.lightBlue),
                      )),
                ],
              ),
            ],
          ),
        )));
  }
}
