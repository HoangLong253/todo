import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../components/avntodocard.dart';
import '../components/provider.dart';
import '../models/todo.dart';
import '../models/todolist.dart';
import 'edit.dart';

class ListScreen extends StatefulWidget {
  ListScreen({
    Key? key,
    required this.color,
    required this.listTitle,
    required this.listId,
  }) : super(key: key);

  Color color;
  final String listTitle;
  String listId;


  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  TextEditingController txtHead = TextEditingController();
  DateTime? time;
  bool? check;
  bool doneCheck = false;

  //final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('lists').doc(widget.listId).collection('todos').snapshots();

  TextEditingController txtTodoHead = TextEditingController();
  String? time1;
  DateTime? day;
  bool? star;


  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('lists').doc(widget.listId).collection('todos').snapshots();

    DateTime now = DateTime.now();
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    initializeDateFormatting('vi', null);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listTitle),
        backgroundColor: widget.color,
      ),
      body: StatefulBuilder(
          builder: (context, todayState) {
            return Column(
              children: [
                //SizedBox(height: 10,),
                Expanded(
                  child: StreamBuilder(
                      stream: stream,
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
                                //String listId = 'PTjd1gVplf4rZXFTVn3d';
                                //String listId = FirebaseFirestore.instance.collection('lists').doc().id;
                                if(documents[index]['listId'] == widget.listId) {
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
                                                    listId: documents[index]['listId'],
                                                    check: 1,
                                                    color: widget.color,
                                                    id: snapshot.data!.docs[index].id,
                                                    title: title,
                                                    day: day,
                                                    time: time,
                                                    star: star,
                                                    content: content,
                                                  )
                                          ),
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
                                                        .collection('lists')
                                                        .doc(widget.listId)
                                                        .collection('todos')
                                                        .doc(snapshot.data!.docs[index].id)
                                                        .delete();
                                                    /*FirebaseFirestore
                                                        .instance
                                                        .collection('cards')
                                                        .doc(toDoId)
                                                        .delete();*/
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
                                        FirebaseFirestore
                                            .instance
                                            .collection('lists')
                                            .doc(widget.listId)
                                            .collection('todos')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'done': !documents[index]['done']});
                                        /*FirebaseFirestore
                                            .instance
                                            .collection('cards')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'done': !documents[index]['done']});*/
                                      });
                                      /*if(documents[index]['done'] == false) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Todo đã được chuyển sang tab hoàn thành, chúc mừng bạn đã hoàn thành mục tiêu đề ra'),
                                          ),
                                        );
                                      }*/
                                    },
                                    starChange: () {
                                      setState(() {
                                        /*FirebaseFirestore.instance.collection('cards')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'star': !documents[index]['star']});*/
                                        FirebaseFirestore
                                            .instance
                                            .collection('lists')
                                            .doc(widget.listId)
                                            .collection('todos')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'star': !documents[index]['star']});
                                      });
                                      /*if(documents[index]['star'] == false) {
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Chuyển sang tab quan trọng thành công'),
                                          ),
                                        );
                                      }*/
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
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        disabledElevation: 20,
        backgroundColor: widget.color,
        heroTag: 'btn',
        onPressed: () => createToDo(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future createToDo() {
    txtTodoHead.clear();
    time = null;
    day = DateTime.now();
    star = false;

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children:  [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextField(
                      controller: txtTodoHead,
                      decoration: const InputDecoration(
                          hintText: 'Nhập tiêu đề todo'
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          StatefulBuilder(
                              builder: (context, dayState) {
                                return ElevatedButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    ).then((value) {
                                      dayState(() {
                                        if(value != null) {
                                          day = DateTime.parse(value.toString());
                                        } else {
                                          day = DateTime.now();
                                        }
                                      });
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(widget.color),
                                    fixedSize: const MaterialStatePropertyAll<Size>(
                                        Size(100, 10)
                                    ),
                                  ),
                                  child: Text(
                                      day == null
                                          ? 'Chọn thứ'
                                          : DateFormat.E('vi').format(day!)
                                  ),
                                );
                              }
                          ),
                          const SizedBox(width: 10,),
                          StatefulBuilder(
                              builder: (context, timeState) {
                                return ElevatedButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                                    ).then((value) {
                                      timeState(() {
                                        if(value?.hour == null && value?.minute == null ) {
                                          time1 = 'Nhắc lúc';
                                        }
                                        else {
                                          time1 = '${value?.hour}:${value?.minute}';
                                        }
                                      });
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(widget.color),
                                    fixedSize: const MaterialStatePropertyAll<Size>(
                                        Size(100, 10)
                                    ),
                                  ),
                                  child: Text(
                                      time1 == null
                                          ? 'Nhắc lúc'
                                          : time1!
                                  ),
                                );
                              }
                          ),
                          const SizedBox(width: 10,),
                          StatefulBuilder(builder: (context, iconState) {
                            return IconButton(
                              onPressed: () {
                                iconState(() {
                                  star = !star!;
                                });
                              },
                              icon: (star == false) ? const Icon(Icons.star_border_outlined) : const Icon(Icons.star, color: Colors.amber,),
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
                        StatefulBuilder(
                            builder: (context, buttonSet) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (txtTodoHead.text.isEmpty) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hãy nhập tiêu đề todo')));
                                  }
                                  else {
                                    day ??= DateTime.now();
                                    final TodoList event1 = TodoList(
                                      listId: widget.listId,
                                      uid: FirebaseAuth.instance.currentUser!.uid,
                                      title: txtTodoHead.text,
                                      time: time.toString(),
                                      day: day,
                                      content: '',
                                      star: star,
                                      done: false,
                                    );
                                    //createTodo(event1);
                                    createTodoList(event1, widget.listId);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm todo thành công')));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(widget.color),
                                  fixedSize: const MaterialStatePropertyAll<Size>(
                                      Size(50, 10)
                                  ),
                                ),
                                child: const Icon(Icons.send),
                              );
                            }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
