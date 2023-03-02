import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ForgotPassLogin extends StatefulWidget {
  const ForgotPassLogin({Key? key}) : super(key: key);

  @override
  State<ForgotPassLogin> createState() => _ForgotPassLoginState();
}

class _ForgotPassLoginState extends State<ForgotPassLogin> {
  TextEditingController txtMail = TextEditingController();
  List<User1> allUser = [];
  bool checkUser = false;
  bool checkEmail = false;

  fetch() async {
    var records = await FirebaseFirestore.instance.collection('users').get();
    getAllUser(records);
  }

  getAllUser(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs.map((e) => User1(
      username: e['username'],
      email: e['email'],
    )).toList();
    allUser = list;
  }

  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 20,),
                const Text(
                  'Đổi mật khẩu',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email hoặc username:',
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
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                  ),
                  onPressed: () {
                    if (txtMail.text.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập email hoặc username')));
                    }
                    else if (txtMail.text.contains(RegExp(r'@'))) {
                      for(var list in allUser) {
                        if (list.email.toString() == txtMail.text){
                          checkEmail = true;
                        }
                      }
                      if(checkEmail) {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: txtMail.text.trim()).then((_) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi link đổi mật khẩu vào email, bạn vui lòng kiểm tra email để tiến hành đổi mật khẩu')));
                        }).catchError((e){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        });
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email hoặc người dùng không tồn tại')));
                      }
                    } else {
                      for(var list in allUser) {
                        if (list.username.toString() == txtMail.text){
                          checkUser = true;
                          txtMail.text = list.email!;
                        }
                      }
                      if(checkUser) {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: txtMail.text.trim()).then((_) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi link đổi mật khẩu vào email đã được lưu trong tài khoản, bạn vui lòng kiểm tra email để tiến hành đổi mật khẩu')));
                        }).catchError((e){
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        });
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email hoặc người dùng không tồn tại')));
                      }
                    }
                    txtMail.clear();
                    //Navigator.of(context).pop();
                  },
                  child: const Text('Gửi',style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Quay lại màn hình đăng nhập', style: TextStyle(color: Colors.blue),)
                ),
              ],
            ),
          ),
        )
    );
  }
}

