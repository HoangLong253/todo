import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class AvnToDoCard extends StatelessWidget {
  const AvnToDoCard({
    Key? key,
    this.title,
    this.day,
    this.time,
    this.star,
    required this.done,
    this.starChange,
    required this.doneChange,
    this.slideChange,
    this.toDoCardChange,
    this.dismissChange
  }) : super(key: key);

  final String? title;
  final String? day;
  final String? time;
  final bool done;
  final bool? star;

  final void Function(bool?) doneChange;
  final void Function(BuildContext)? slideChange;
  final void Function(DismissDirection)? dismissChange;
  final VoidCallback? starChange;
  final VoidCallback? toDoCardChange;


  @override
  Widget build(BuildContext context) {
    Timestamp now = Timestamp.now();

    return Column(
      children: [
        const SizedBox(height: 5,),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Slidable(
              endActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: slideChange,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Xoá',
                  ),
                ],
              ),
              child: InkWell(
                  onTap: toDoCardChange,
                  child: ListTile(
                    leading: Checkbox(
                      value: done,
                      onChanged: doneChange,
                    ),
                    title: Text('$title', style: TextStyle(decoration: done ? TextDecoration.lineThrough : TextDecoration.none),),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 19,),
                        const SizedBox(width: 3,),
                        Text(DateFormat('d', 'vi').format(now.toDate()) == day
                            ? 'Hôm nay'
                            : day.toString()),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: starChange,
                        icon: star == true
                            ? const Icon(Icons.star, color: Colors.amber,)
                            : const Icon(Icons.star_border_outlined)
                    ),
                  ),
              )
          ),
        )
      ],
    );
  }
}