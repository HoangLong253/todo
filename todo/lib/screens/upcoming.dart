import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../components/avntodocard.dart';
import '../components/todocard.dart';
import 'edit.dart';

class Upcoming extends StatefulWidget {
  Upcoming({
    Key? key,
    required this.color
  }) : super(key: key);

  Color color;

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('cards').snapshots();
  TextEditingController txtHead = TextEditingController();
  DateTime? time;
  bool? check;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  DateTime now = DateTime.now();

  bool? isEdit;

  @override
  void initState() {
    // TODO: implement initState
    isEdit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi', null);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  } else if(snapshot.hasError) {
                    return const Center(
                      child: Text('Lỗi'),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Không có dữ liệu'),
                    );
                  } else {
                    final documents = snapshot.data!.docs;
                    int total = snapshot.data!.docs.length;
                    return ListView.builder(
                        itemCount:  total,
                        itemBuilder: (context, index) {
                          Timestamp toDoDayTimeStamp = documents[index]['day'];
                          DateTime today = DateTime.now();
                          DateTime toDoDay = toDoDayTimeStamp.toDate();

                          if((toDoDay.isAfter(today) &&
                              documents[index]['uid'] == uid) &&
                              documents[index]['done'] == false)
                          {
                            String toDoId = snapshot.data!.docs[index].id;
                            return AvnToDoCard(
                              toDoCardChange: () {
                                String title = documents[index]['title'];
                                Timestamp day = documents[index]['day'];
                                String time = documents[index]['time'];
                                bool star = documents[index]['star'];
                                bool done = documents[index]['done'];
                                String content = documents[index]['content'];
                                setState(() {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Edit(
                                                check: 0,
                                                color: widget.color,
                                                id: toDoId,
                                                title: title,
                                                day: day,
                                                time: time,
                                                star: star,
                                                content: content,
                                              )
                                      )
                                  );
                                });
                              },
                              slideChange: (context) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Thông báo'),
                                      content: const Text('Bạn đã chắc chưa ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              FirebaseFirestore
                                                  .instance
                                                  .collection('cards')
                                                  .doc(toDoId)
                                                  .delete();
                                            });
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
                              title: documents[index]['title'],
                              day: DateFormat('E', 'vi').format(((documents[index]['day'])).toDate()),
                              time: documents[index]['time'],
                              done: documents[index]['done'],
                              star: documents[index]['star'],
                              doneChange: (value) {
                                setState(() {
                                  FirebaseFirestore.instance.collection('cards')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({'done': !documents[index]['done']});
                                });
                                if(documents[index]['done'] == false) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Todo đã được chuyển sang tab hoàn thành, chúc mừng bạn đã hoàn thành mục tiêu đề ra'),
                                    ),
                                  );
                                }
                              },
                              starChange: () {
                                setState(() {
                                  FirebaseFirestore.instance.collection('cards')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({'star': !documents[index]['star']});
                                });
                                if(documents[index]['star'] == false) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Chuyển sang tab quan trọng thành công'),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                          else {
                            return Container();
                          }
                        }
                    );
                  }
                }
            ),
          ),
        ],
      ),
    );
  }
}