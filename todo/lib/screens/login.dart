import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/forgotpasslogin.dart';
import 'package:todo/screens/register.dart';

import 'auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtMail = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  String test = '';

  bool cpass = true;
  bool change = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    Future login2(String email) async {
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: txtPass.text
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'wrong-password': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập sai mật khẩu')));
            break;
          }
          case 'invalid-email': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập sai email')));
            break;
          }
          case 'user-not-found': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không tìm thấy email/user')));
            break;
          }
        }
        //ScaffoldMessenger.of(context).clearSnackBars();
        return e;
      }
    }

    Future login() async {
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          //email: snap.docs[0]['email'],
          email: txtMail.text.trim(),
          password: txtPass.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'wrong-password': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập sai mật khẩu')));
            break;
          }
          case 'invalid-email': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập sai email')));
            break;
          }
          case 'user-not-found': {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không tìm thấy email/user')));
            break;
          }
        }
        return e;
      }
    }

    return Scaffold(
      key: _scaffoldKey,
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
              const SizedBox(height: 10,),
              const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email hoặc username',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    color: Colors.white,
                    child: TextField(
                        controller: txtMail,
                        obscureText: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Colors.blue)
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Nhập email hoặc username',
                            hintStyle: TextStyle(color: Colors.grey)
                        )
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
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
                        controller: txtPass,
                        obscureText: cpass,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cpass = !cpass;
                                });
                              },
                              child: Icon(cpass ? Icons.visibility : Icons.visibility_off),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Colors.blue)
                            ),
                            border: const OutlineInputBorder(),
                            hintText: 'Nhập password',
                            hintStyle: const TextStyle(color: Colors.grey)
                        )
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.55),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPassLogin()));
                    },
                    child: const Text('Quên mật khẩu?', style: TextStyle(color: Colors.blue),)
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                  ),
                  onPressed: () async {
                    if(txtMail.text.isEmpty || txtPass.text.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đầy đủ các trường dữ liệu')));
                    } else if(txtMail.text.contains(RegExp(r'@')))
                      {
                        login();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Auth()),
                                (route) => false
                        ).then((value) {
                          if(FirebaseAuth.instance.currentUser != null) {
                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')));
                          }
                        });
                      }
                    else {
                      QuerySnapshot snap =
                      await FirebaseFirestore
                          .instance
                          .collection("users")
                          .where("username", isEqualTo: txtMail.text)
                          .get();
                      if (!context.mounted) return;
                      if(txtMail.text.isEmpty || txtPass.text.isEmpty) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đầy đủ các trường dữ liệu')));
                      } else {
                        if (snap.docs.isEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username/email không có trong hệ thống')));
                        }
                        else {
                          login2(snap.docs[0]['email'].toString());
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const Auth()),
                                  (route) => false
                          );
                          /*.then((value) {
                            if(FirebaseAuth.instance.currentUser == null) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nhập sai email/tên người dùng hoặc password')));
                            }
                            else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập thành công')));
                            }
                          });*/
                        }
                      }
                    }
                    txtPass.text = '';
                    txtMail.text = '';
                    txtUsername.text = '';
                  },
                  child: const Text('Đăng nhập',style: TextStyle(color: Colors.white),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?, '),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Register()),
                                (route) => route.isFirst
                        );
                      },
                      child: const Text('đăng ký ngay', style: TextStyle(color: Colors.lightBlue),)
                  ),
                ],
              ),
              Text(test, style: const TextStyle(color: Colors.black),),
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtMail.dispose();
    txtPass.dispose();
    txtUsername.dispose();
    super.dispose();
  }
}

/*Column(
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
                        controller: txtMail,
                        obscureText: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2, color: Colors.blue)
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Nhập email',
                            hintStyle: TextStyle(color: Colors.grey)
                        )
                    ),
                  )
                ],
              ),*/

/*InkWell(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Menu()),
                    (route) => false
                );
              },
              child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text('Đăng nhập'),
                  )
              ),
            ),*/

/*if(txtUsername.text.isEmpty || txtMail.text.isEmpty || txtPass.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                      Text('Vui lòng nhập đầy đủ các trường dữ liệu')));
                } else if (txtPass.text != txtCf.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password không trùng khớp')));
                } else {
                  register();

                  txtUsername.text = '';
                  txtMail.text = '';
                  txtPass.text = '';
                  txtCf.text = '';
                }*/
