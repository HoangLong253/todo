import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  ListCard({
    Key? key,
    required this.color,
    this.listTitle,
    required this.listId,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  Color color;
  String? listTitle;
  String listId;

  VoidCallback? onTap;
  VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {

    Timestamp now = Timestamp.now();
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
          padding: const EdgeInsets.only(left: 20),
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.menu, color: Colors.black54, size: 35),
              const SizedBox(width: 12,),
              Text(listTitle!, style: const TextStyle(fontSize: 17),),
            ],
          )
      ),
    );
  }
}

