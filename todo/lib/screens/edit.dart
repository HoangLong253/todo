import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Edit extends StatefulWidget {
  Edit(
      {Key? key,
      this.check,
      required this.color,
      required this.id,
      this.title,
      required this.day,
      required this.time,
      required this.star,
      this.done,
      required this.content,
      this.listId})
      : super(key: key);

  int? check = 0;
  String id;
  late String? title;
  Timestamp day;
  String time;
  bool star;
  late bool? done;
  String content;
  Color color;

  String? listId;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtNote = TextEditingController();

  bool? isEdit;

  @override
  void initState() {
    // TODO: implement initState
    isEdit = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    bool starTemp = widget.star;

    String dayTempS = DateFormat('E', 'vi').format(
        DateTime.fromMillisecondsSinceEpoch(widget.day.millisecondsSinceEpoch));
    DateTime? day =
        DateTime.fromMicrosecondsSinceEpoch(widget.day.microsecondsSinceEpoch);

    String timeTempS = widget.time;
    //Timestamp time;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sửa ghi chú',
          ),
          backgroundColor: widget.color,
          actions: [
            IconButton(
                onPressed: () {
                  if (!isEdit!) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Dữ liệu không thay đổi')));
                  } else if (widget.check == 1) {
                    FirebaseFirestore.instance
                        .collection('lists')
                        .doc(widget.listId)
                        .collection('todos')
                        .doc(widget.id)
                        .update({
                      'title': widget.title,
                      'day': day,
                      'time': timeTempS,
                      'star': widget.star,
                      'content': widget.content,
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sửa thành công')));
                  } else {
                    FirebaseFirestore.instance
                        .collection('cards')
                        .doc(id)
                        .update({
                      'title': widget.title,
                      'day': day,
                      'time': timeTempS,
                      'star': widget.star,
                      'content': widget.content,
                    });
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sửa thành công')));
                  }
                  //Navigator.of(context).pop();
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Row(
                      children: [
                        Text(
                          widget.title.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              txtTitle.text = widget.title.toString();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Đổi tên'),
                                  content: TextField(
                                    controller: txtTitle,
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.title = txtTitle.text;
                                            isEdit = true;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Ok')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Huỷ')),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: widget.color,
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.color,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        StatefulBuilder(builder: (context, dayState) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                isEdit = true;
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                ).then((value) {
                                  dayState(() {
                                    if (value != null) {
                                      day = DateTime.parse(value.toString());
                                      dayTempS =
                                          DateFormat('E', 'vi').format(day!);
                                    } else {
                                      day = DateTime.fromMicrosecondsSinceEpoch(
                                          widget.day.microsecondsSinceEpoch);
                                      dayTempS =
                                          DateFormat('E', 'vi').format(day!);
                                    }
                                  });
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Text(
                                        'Chọn thứ',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                      ),
                                      Text(
                                        //DateFormat('E', 'vi').format(DateTime.fromMillisecondsSinceEpoch(widget.day.millisecondsSinceEpoch))
                                        dayTempS,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        }),
                        StatefulBuilder(builder: (context, timeState) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                isEdit = true;
                                showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(DateTime.now()),
                                ).then((value) {
                                  timeState(() {
                                    if (value?.hour == null &&
                                        value?.minute == null) {
                                      timeTempS = '';
                                    } else {
                                      timeTempS =
                                          '${value?.hour}:${value?.minute}';
                                    }
                                  });
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Text(
                                        'Chọn giờ:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                      ),
                                      Text(
                                          timeTempS == 'null' ? '' : timeTempS),
                                    ],
                                  )),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                padding: const EdgeInsets.only(left: 20),
                                height: 60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text(
                                      'Quan trọng',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                    ),
                                    StatefulBuilder(
                                      builder: (context, starChange) =>
                                          IconButton(
                                              onPressed: () {
                                                setState(() {});
                                                starChange(() {
                                                  isEdit = true;
                                                  //starTemp = !starTemp;
                                                  widget.star = !widget.star;
                                                  //widget.star = starTemp;
                                                });
                                              },
                                              icon: widget.star == true
                                                  ? const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )
                                                  : const Icon(Icons
                                                      .star_border_outlined)),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        const Text(
                          'Note:',
                          style: TextStyle(fontSize: 17),
                        ),
                        StatefulBuilder(builder: (context, noteChange) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEdit = true;
                                });
                                txtNote.text = widget.content;
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10),
                                                child: TextField(
                                                  controller: txtNote,
                                                  maxLines: 3,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          noteChange(() {
                                                            widget.content =
                                                                txtNote.text;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .blue),
                                                          fixedSize:
                                                              const MaterialStatePropertyAll<
                                                                      Size>(
                                                                  Size(50, 10)),
                                                        ),
                                                        child:
                                                            const Text('Lưu'))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Container(
                                      height: 200,
                                      width: 325,
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            widget.content,
                                          )))));
                        }),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
