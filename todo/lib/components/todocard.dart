import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatefulWidget {
  TodoCard({
    Key? key,
    this.doneCheck,
    this.title,
    required this.time,
    this.day,
    this.starCheck,
    required this.doneChange,
    this.starChange
  }) : super(key: key);

  String? title;
  String? time;
  String? day;
  bool? doneCheck;
  bool? starCheck;
  void Function(bool?) doneChange;
  VoidCallback? starChange;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  Timestamp now = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.doneCheck,
        onChanged: widget.doneChange,
      ),
      title: Text('${widget.title}'),
      subtitle: Row(
        children: [
          const Icon(Icons.calendar_month, size: 19,),
          const SizedBox(width: 3,),
          Text(
              DateFormat('E', 'vi').format(now.toDate()) == widget.day
                  ? 'Hôm nay'
                  : widget.day.toString()
          ),
        ],
      ),
      trailing: IconButton(
          onPressed: widget.starChange,
          icon: widget.starCheck == true
              ? const Icon(Icons.star, color: Colors.amber,)
              : const Icon(Icons.star_border_outlined)
      ),
    );
  }
}
