import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task extends StatelessWidget {
  Task({Key? key,
    required this.value,
    required this.text,
    required this.onChanged,
    required this.deleteFunc,
  }) : super(key: key);

  bool? value;
  final String text;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(

          ),
          children: [
            SlidableAction(
              onPressed: deleteFunc,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
              ),
              Text(
                text,
                style: TextStyle(decoration: (value!) ? TextDecoration.lineThrough : TextDecoration.none),
              )
            ],
          ),
        ),
      )
    );
  }
}

