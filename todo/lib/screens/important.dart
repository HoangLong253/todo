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

class Important extends StatefulWidget {
  Important({
    Key? key,
    required this.color,
  }) : super(key: key);

  Color color;

  @override
  State<Important> createState() => _ImportantState();
}

class _ImportantState extends State<Important> {
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
          /*InkWell(
            onTap: () {
              time = null;
              check = false;
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Column(
                        children:  [
                          const SizedBox(height: 10,),
                          const Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Nhập tiêu đề todo'
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  StatefulBuilder(
                                      builder: (context, sSt) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            DateTime? onlyTime;
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100),
                                            ).then((value1) {
                                              DateTime now = DateTime.now();
                                              showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.fromDateTime(now),
                                              ).then((value){
                                                sSt(() {
                                                  if(value1 == null || value == null) {
                                                    time = null;
                                                  }
                                                  else {
                                                    onlyTime = DateTimeField.combine(value1 as DateTime, value);
                                                    time = onlyTime;
                                                  }
                                                });
                                              });
                                            });
                                          },
                                          style: const ButtonStyle(
                                            fixedSize: MaterialStatePropertyAll<Size>(
                                                Size(100, 10)
                                            ),
                                          ),
                                          child: Text(
                                              time == null
                                                  ? 'Thời gian'
                                                  : DateFormat.E('vi').format(time!) + ' ' + DateFormat.Hm('vi').format(time!)
                                          ),
                                        );
                                      }
                                  ),
                                  const SizedBox(width: 10,),
                                  StatefulBuilder(builder: (context, iconState) {
                                    return IconButton(
                                      onPressed: () {
                                        iconState(() {
                                          check = !check!;
                                        });
                                      },
                                      icon: (check == false) ? Icon(Icons.star_border_outlined) : Icon(Icons.star),
                                    );
                                  }),
                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                    fixedSize: const MaterialStatePropertyAll<Size>(
                                        Size(50, 10)
                                    ),
                                  ),
                                  child: const Icon(Icons.send),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              );
            },
            child: Container(
                padding: EdgeInsets.only(left: 20,),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.black54, size: 25,),
                    SizedBox(width: 10,),
                    Text('Tạo to-do', style: TextStyle(fontSize: 20),),
                  ],
                )
            ),
          ),*/
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
                          int toDoDay = int.parse(DateFormat('d', 'vi').format(((documents[index]['day'])).toDate()));
                          int toDoMonth = int.parse(DateFormat('M', 'vi').format(((documents[index]['day'])).toDate()));
                          int toDoYear = int.parse(DateFormat('y', 'vi').format(((documents[index]['day'])).toDate()));

                          int today = int.parse(DateFormat('d', 'vi').format(now));
                          int monthNow = int.parse(DateFormat('M', 'vi').format(now));
                          int yearNow = int.parse(DateFormat('y', 'vi').format(now));

                          bool check = (toDoDay >= today || toDoMonth >= monthNow || toDoYear >= yearNow);
                          if((check &&
                              documents[index]['uid'] == uid) &&
                              documents[index]['star'] == true &&
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
                                if(documents[index]['star'] == true) {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Gỡ quan trọng cho todo thành công'),
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
