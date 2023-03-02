import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  String? username;
  String? email;
  String? uid;

  User1({
    this.username,
    this.email,
    this.uid,
  });

  Map<String, dynamic> toJSON() => {
    'username': username,
    'email': email,
    'uid': uid,
  };

  static User1 fromJSON(Map<String, dynamic> json) => User1(
    username: json['username'],
    email: json['email'],
    uid: json['uid'],
  );

  Map<String, dynamic> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
    };
  }

  factory User1.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return User1(
      username: data?['username'],
      email: data?['email'],
    );
  }
}