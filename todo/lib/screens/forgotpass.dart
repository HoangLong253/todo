import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({
    Key? key,
    required this.color
  }) : super(key: key);

  final Color color;

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController txtCurrPass = TextEditingController();
  TextEditingController txtNewPass = TextEditingController();
  TextEditingController txtCheck = TextEditingController();

  bool currPass = true;
  bool newPass = true;
  bool checkPass = true;

  void _changePassword(String pass) async {
    var user = FirebaseAuth.instance.currentUser;

    user!.updatePassword(pass).then((_) {
      //FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi pass thành công')));
    });
  }

  @override
  Widget build(BuildContext context) {
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: widget.color,
      ),
      body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 'Mật khẩu hiện tại: ',
                 textAlign: TextAlign.left,
                 style: TextStyle(fontSize: 15, color: Colors.black),
               ),
               Container(
                 width: MediaQuery.of(context).size.width / 1.2,
                 color: Colors.white,
                 child: TextField(
                     controller: txtCurrPass,
                     obscureText: currPass,
                     style: const TextStyle(color: Colors.black),
                     decoration:  InputDecoration(
                         suffixIcon: GestureDetector(
                           onTap: () {
                             setState(() {
                               currPass = !currPass;
                             });
                           },
                           child: Icon(currPass ? Icons.visibility : Icons.visibility_off),
                         ),
                         enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color )
                         ),
                         focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color)
                         ),
                         focusColor: widget.color,
                         border: const OutlineInputBorder(),
                         hintText: 'Nhập mật khẩu cũ',
                         hintStyle: const TextStyle(color: Colors.grey)
                     )
                 ),
               ),
             ],
           ),
           const SizedBox(height: 20,),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 'Mật khẩu mới: ',
                 textAlign: TextAlign.left,
                 style: TextStyle(fontSize: 15, color: Colors.black),
               ),
               Container(
                 width: MediaQuery.of(context).size.width / 1.2,
                 color: Colors.white,
                 child: TextField(
                     controller: txtNewPass,
                     obscureText: newPass,
                     style: const TextStyle(color: Colors.black),
                     decoration: InputDecoration(
                         suffixIcon: GestureDetector(
                           onTap: () {
                             setState(() {
                               newPass = !newPass;
                             });
                           },
                           child: Icon(newPass ? Icons.visibility : Icons.visibility_off),
                         ),
                         enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color)
                         ),
                         focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color)
                         ),
                         focusColor: widget.color,
                         border: const OutlineInputBorder(),
                         hintText: 'Nhập mật khẩu mới',
                         hintStyle: const TextStyle(color: Colors.grey)
                     )
                 ),
               ),
             ],
           ),
           const SizedBox(height: 20,),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text(
                 'Xác nhận mật khẩu: ',
                 textAlign: TextAlign.left,
                 style: TextStyle(fontSize: 15, color: Colors.black),
               ),
               Container(
                 width: MediaQuery.of(context).size.width / 1.2,
                 color: Colors.white,
                 child: TextField(
                     controller: txtCheck,
                     obscureText: checkPass,
                     style: const TextStyle(color: Colors.black),
                     decoration: InputDecoration(
                         suffixIcon: GestureDetector(
                           onTap: () {
                             setState(() {
                               checkPass = !checkPass;
                             });
                           },
                           child: Icon(checkPass ? Icons.visibility : Icons.visibility_off),
                         ),
                         enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color)
                         ),
                         focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(width: 2, color: widget.color)
                         ),
                         focusColor: widget.color,
                         border: const OutlineInputBorder(),
                         hintText: 'Xác nhận mật khẩu',
                         hintStyle: const TextStyle(color: Colors.grey)
                     )
                 ),
               ),
             ],
           ),
           const SizedBox(height: 20,),
           InkWell(
               onTap: () async {
                 if(txtCurrPass.text.isEmpty || txtNewPass.text.isEmpty || txtCheck.text.isEmpty) {
                   ScaffoldMessenger.of(context).clearSnackBars();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                       content:
                       Text('Vui lòng nhập đầy đủ các trường dữ liệu')));
                 } else if(txtNewPass.text.length < 8 && !passValid.hasMatch(txtNewPass.text.trim())) {
                   ScaffoldMessenger.of(context).clearSnackBars();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                       content:
                       Text('Mật khẩu mới cần ít nhất 8 kí tự, chứa ít nhất 1 chữ cái viết hoa và 1 kí tự đặc biệt')));
                 } else if (txtNewPass.text != txtCheck.text) {
                   ScaffoldMessenger.of(context).clearSnackBars();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                       content:
                       Text('Mật khẩu không trùng nhau')));
                 } else {
                   var user = FirebaseAuth.instance.currentUser!;
                   var authResult = EmailAuthProvider.credential(
                     email: user.email!,
                     password: txtCurrPass.text,
                   );
                   try {
                     user.reauthenticateWithCredential(authResult).then((value) {
                       user.updatePassword(txtNewPass.text.trim()).then((_) {
                         ScaffoldMessenger.of(context).clearSnackBars();
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đổi mật khẩu thành công')));
                         txtCurrPass.clear();
                         txtNewPass.clear();
                         txtCheck.clear();
                       });
                     });
                   } on FirebaseAuthException catch (e) {
                     switch(e.code) {
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
                   }
                   txtCurrPass.clear();
                   txtNewPass.clear();
                   txtCheck.clear();
                 }
               },
               child: Container(
                 decoration: BoxDecoration(
                     color: widget.color,
                     shape: BoxShape.rectangle,
                     borderRadius: BorderRadius.circular(50)
                 ),
                 padding: const EdgeInsets.only(left: 75, right: 75, top: 10, bottom: 10),
                 child: const Text('Đổi mật khẩu',
                   style: TextStyle(
                       color: Colors.white,
                       fontSize: 16,
                       fontWeight: FontWeight.w500
                   ),),
               )
           ),
         ],
       ),
      ),
    );
  }
}
