import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/auth.dart';
import 'package:todo/screens/forgotpass.dart';

import '../components/provider.dart';
import '../models/user.dart';

class Info extends StatefulWidget {
  Info({
    Key? key,
    required this.color,
    this.username,
    this.email,
  }) : super(key: key);

  Color color;
  String? username;
  String? email;

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  var user = FirebaseAuth.instance.currentUser!;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  List<User1> alluser = [];
  bool checkUser = false;
  bool checkEmail = false;
  bool cpass = true;

  fetch() async {
    var records = await FirebaseFirestore.instance.collection('users').get();
    getAllUser(records);
  }

  getAllUser(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs.map((e) => User1(
      username: e['username'],
      email: e['email'],
    )).toList();
    alluser = list;
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
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: widget.color,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.account_circle,
                size: 200, //98
                color: widget.color,
              ),
              const Text('Thông tin cá nhân', style: TextStyle(fontSize: 20),),
              /*Padding(
                padding: const EdgeInsets.only (left: 40, right: 40, ),
                child:
              ),*/
              /*ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(widget.color),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(0, 25),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => FutureBuilder(
                          future: getUser(uid),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(),);
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Đã xảy ra sự cố'),);
                            } else if(!snapshot.hasData) {
                              return const Center(child: Text('Không có dữ liệu'),);
                            } else {
                              final user = snapshot.data;
                              return user == null
                                  ? const Center(child: Text('Đã xảy ra sự cố'),)
                                  : Center(child: buildEdit(user));
                            }
                          }
                      ),
                  );
                },
                child: const Text('Chỉnh sửa'),
              ),*/
              const SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => FutureBuilder(
                        future: getUser(uid),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(),);
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('Đã xảy ra sự cố'),);
                          } else if(!snapshot.hasData) {
                            return const Center(child: Text('Không có dữ liệu'),);
                          } else {
                            final user = snapshot.data;
                            return user == null
                                ? const Center(child: Text('Đã xảy ra sự cố'),)
                                : Center(child: buildEdit(user));
                          }
                        }
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  padding: const EdgeInsets.only(left: 75, right: 75, top: 10, bottom: 10),
                  child: const Text('Chỉnh sửa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),),
                )
              ),
              const SizedBox(height: 13,),
              FutureBuilder<User1?>(
                future: getUser(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if(snapshot.hasError) {
                    return const Center(child: Text('Lỗi'));
                  } else if (!snapshot.hasData){
                    return const Center(child: Text('Không có dữ liệu'));
                  } else {
                    final user = snapshot.data;
                    return user == null
                        ? const Center(child: Text('Đã xảy ra sự cố'),)
                        : buildsmth(user);
                  }
                },
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.red),
                    ),
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPass(color: widget.color,)));
                          /*showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Thông báo'),
                                content: const Text('Bạn đã chắc chưa ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: const Text('Ok'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Huỷ'),
                                  ),
                                ],
                              )
                          );*/
                        },
                        child: const Center(child: Text('Đổi mật khẩu', style: TextStyle(fontSize: 15, color: Colors.red),))
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.red),
                    ),
                    child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Thông báo'),
                                content: const Text('Bạn đã chắc chưa ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        //String uid = FirebaseAuth.instance.currentUser!.uid;
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
                                      });
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Huỷ'),
                                  ),
                                ],
                              )
                          );
                        },
                        child: const Center(child: Text('Xoá tài khoản', style: TextStyle(fontSize: 15, color: Colors.red),))
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.red),
                    ),
                    child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Thông báo'),
                                content: const Text('Bạn đã chắc chưa ?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => const Auth()
                                              ),
                                                  (route) => route.isFirst
                                          );
                                        });
                                      },
                                      child: const Text('Ok'),
                                  ),
                                  TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Huỷ'),
                                  ),
                                ],
                              )
                          );
                        },
                        child: const Center(child: Text('Đăng xuất', style: TextStyle(fontSize: 15, color: Colors.red),))
                    )
                ),
              ),
              const SizedBox(height: 15,),
            ]
          )
        )
      )
    );
  }

  Widget buildsmth(User1 us) =>
      Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: widget.color
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Tên người dùng",
                      //border: OutlineInputBorder()
                    ),
                    controller: TextEditingController(
                      text: us.username,
                    ),
                  ),
                  //const SizedBox(height: 20,),
                  TextField(
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      //border: OutlineInputBorder(),
                    ),
                    controller: TextEditingController(
                      text: us.email,
                    ),
                  ),
                  const SizedBox(height: 15,)
                ],
              )
          )
      );

  Widget buildEdit(User1 user1) {
    txtUsername.text = user1.username!;
    txtEmail.text = user1.email!;
    txtPass.clear();
    return AlertDialog(
          title: const Text('Sửa thông tin người dùng'),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: 200,
                width: 200,
                child: ListView(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Tên người dùng:'
                      ),
                      onChanged: (value) {
                        setState(() {
                          checkUser = false;
                        });
                      },
                      controller: txtUsername,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Email:'
                      ),
                      onChanged: (value) {
                        setState(() {
                          checkEmail = false;
                        });
                      },
                      controller: txtEmail,
                    ),
                    StatefulBuilder(
                        builder: (context, passState) {
                          return TextField(
                            obscureText: cpass,
                            decoration: InputDecoration(
                              labelText: 'Nhập mật khẩu để xác nhận đổi tên username/email:',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  passState(() {
                                    cpass = !cpass;
                                  });
                                },
                                child: Icon(cpass ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            controller: txtPass,
                          );
                        }
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  checkUser = false;
                  checkEmail = false;
                  for(var list in alluser) {
                    if (list.username.toString() == txtUsername.text && list.uid != FirebaseAuth.instance.currentUser?.uid){
                      checkUser = true;
                    }
                    if (list.email.toString() == txtEmail.text && list.uid != FirebaseAuth.instance.currentUser?.uid){
                      checkEmail = true;
                    }
                  }
                  if (txtPass.text.isEmpty) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập mật khẩu để đổi username/email')));
                  } else if(checkUser) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username đã được dùng, vui lòng đổi sang tên khác')));
                  } else if (checkEmail && user.email != txtEmail.text) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email đã được dùng, vui lòng đổi sang email khác')));
                  } else {
                    var user = FirebaseAuth.instance.currentUser!;
                    var authResult = await user.reauthenticateWithCredential(
                      EmailAuthProvider.credential(
                        email: user.email!,
                        password: txtPass.text,
                      ),
                    );
                    authResult.user!.updateEmail(txtEmail.text);
                    FirebaseFirestore.instance.collection('users').doc(uid).update({
                      'username': txtUsername.text,
                      'email': txtEmail.text,
                    });
                    if (!context.mounted) return;
                    //FirebaseAuth.instance.currentUser!.updateEmail(txtEmail.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Auth()), (route) => route.isCurrent);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi thành công')));
                  }
                },
                child: const Text('Ok')
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Huỷ')
            ),
          ],
        );
  }
}

/*Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: widget.color
                      ),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: "Tên người dùng",
                            //border: OutlineInputBorder()
                          ),
                          controller: TextEditingController(
                            text: txtUsername.text,
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextField(
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            //border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: txtEmail.text,
                          ),
                        ),
                      ],
                    )
                )
            ),*/
/*showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('text'),
                      actions: [
                        TextButton(onPressed: () {}, child: Text('hi'))
                      ],
                    )
                        /*FutureBuilder(
                            future: getUser(uid),
                            builder: (context, snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(),);
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Đã xảy ra sự cố'),);
                              } else if(!snapshot.hasData) {
                                return const Center(child: Text('Không có dữ liệu'),);
                              } else {
                                final user = snapshot.data;
                                return user == null
                                    ? const Center(child: Text('Đã xảy ra sự cố'),)
                                    : buildEdit(user);
                              }
                            }
                        ),*/
                    /*AlertDialog(
                        title: const Text('Sửa thông tin người dùng'),
                        content: Column(
                          children: [
                            TextField(
                              controller: txtUsername,
                            ),
                            TextField(
                              controller: txtEmail,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                setState(() {

                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok')
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Huỷ')
                          ),
                        ],
                      ),*/
                  );*/
/*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sửa thông tin'),
                  ),

                  ElevatedButton(
                      onPressed: () {},
                      child: const Text('Xoá tài khoản')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Đăng xuất')
                  ),
                ],
              )*/
/*Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                    ),
                    child: InkWell(
                        onTap: () {

                        },
                        child: const Center(child: Text('Sửa thông tin', style: TextStyle(fontSize: 15),))
                    )
                ),
              ),*/

/*FutureBuilder<User1?>(
                future: getUser(uid),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Center(child: Text('Lỗi'));
                  } else if(snapshot.hasData){
                    final user = snapshot.data;
                    return user == null
                        ? Center(child: Text('lỗi'),)
                        : buildUser(user, uid);
                  } else {
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
              ),*/

/*Widget buildUser(User1 us, uid) => Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    //Text(us.username.toString(), style: TextStyle(fontSize: 20),),
    //SizedBox(height: 15,)
  ],
);*/
