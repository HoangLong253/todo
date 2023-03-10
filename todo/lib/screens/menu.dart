import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/listcard.dart';
import '../models/todo.dart';
import '../models/list.dart';
import '../models/user.dart';
import 'info.dart';
import 'listscreen.dart';
import 'outdated.dart';
import 'package:todo/components/provider.dart';
import 'package:todo/screens/done.dart';
import 'package:todo/screens/important.dart';
import 'package:todo/screens/today.dart';
import 'package:todo/screens/upcoming.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  String headtext = 'To do';
  bool change = false;


  List<int> index1 = [0, 1, 2, 3, 4];
  int index2 = 0;
  int tabBarChange = 1;
  bool switchChange = false;
  Color headColor = Colors.blue;

  TextEditingController txtTodoHead = TextEditingController();
  String? time;
  DateTime? day;
  bool? star;

  double iconSize = 35;
  double textSize = 17;

  //bien them danh sach
  TextEditingController txtListName = TextEditingController();
  Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection('lists').snapshots();



  Future signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget buildUser(User1 us, uid) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 30,),
      Icon(
        Icons.account_circle,
        size: 150,
        color: headColor,
      ),
      Text(us.username.toString(), style: const TextStyle(color: Colors.black, fontSize: 20)),
    ],
  );

  @override
  Widget build(BuildContext context) {

    List<Widget> indexedList = [
      Today(color: headColor,),
      Upcoming(color: headColor,),
      Important(color: headColor,),
      Done(color: headColor,),
      Outdated(color: headColor,),
    ];

    return Scaffold(
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.73,
        child: ListView(
          padding: EdgeInsets.zero,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //thong tin tai khoan
            Center(
              child: Stack(
                //alignment: Alignment.topCenter,
                children: [
                  FutureBuilder<User1?>(
                    future: getUser(uid),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('???? x???y ra s??? c???'),);
                      } else if(!snapshot.hasData) {
                        return const Center(child: Text('Kh??ng c?? d??? li???u'),);
                      } else {
                        final user = snapshot.data;
                        return user == null
                            ? const Center(child: Text('???? x???y ra s??? c???'),)
                            : buildUser(user, uid);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.only(left: 33, right: 33),
              child: InkWell(
                  onTap: () =>
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Info(color: headColor,))),
                  child: Container(
                      decoration: BoxDecoration(
                          color: headColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: const EdgeInsets.only(left: 50, right: 50, top: 3, bottom: 3 ),
                      child: const Center(child: Text(
                        'Ch???nh s???a',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),
                      ),)
                  )
              ),
            ),
            const SizedBox(height: 7,),
            const Divider(
              color: Colors.black87,
            ),
            //ket thuc thong tin tai khoan

            //5 tab mac dinh
            InkWell(
              onTap: () {
                setState(() {
                  index2 = 0;
                  headtext = 'H??m nay';
                  headColor = Colors.blue;
                });
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  color: (index2 == 0) ? Colors.black12 : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      Icon(
                        Icons.today,
                        color: Colors.blue,
                        size: iconSize,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        'H??m nay',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: textSize
                        ),
                      ),
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index2 = 1;
                  headtext = 'S???p t???i';
                  headColor = Colors.pink;
                });
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  color: (index2 == 1) ? Colors.black12 : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.upcoming, color: Colors.pink, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text(
                        'S???p t???i',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: textSize
                        ),
                      ),
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index2 = 2;
                  headtext = 'Quan tr???ng';
                  headColor = Colors.amber;
                });
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  color: (index2 == 2) ? Colors.black12 : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text(
                        'Quan tr???ng',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: textSize
                        ),
                      ),
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index2 = 3;
                  headtext = 'Ho??n th??nh';
                  headColor = Colors.green;
                });
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  color: (index2 == 3) ? Colors.black12 : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text(
                        'Ho??n th??nh',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: textSize,
                        ),
                      ),
                    ],
                  )
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  index2 = 4;
                  headtext = 'Qu?? h???n';
                  headColor = Colors.black45;
                });
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  color: (index2 == 4) ? Colors.black12 : Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.move_down, color: Colors.black45, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text(
                        'Qu?? h???n',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: textSize
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const Divider(
              color: Colors.black38,
            ),
            //them danh sach
            InkWell(
              onTap: () {
                txtListName.clear();
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Th??m danh s??ch'),
                      content: TextField(
                        controller: txtListName,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: headColor)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: headColor)
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if(txtListName.text.isEmpty) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('H??y nh???p ti??u ????? list')));
                            } else {
                              final listId = FirebaseFirestore.instance.collection('lists').doc().id;
                              final ListObj lst1 = ListObj(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  listName: txtListName.text,
                                  listId: listId
                              );
                              createList(lst1, listId);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Th??m list th??nh c??ng')));
                            }
                          },
                          child: Text('Th??m', style: TextStyle(color: headColor),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Hu???', style: TextStyle(color: headColor),),
                        ),
                      ],
                    )
                );
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black54, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text('Th??m danh s??ch m???i', style: TextStyle(fontSize: textSize),),
                    ],
                  )
              ),
            ),
            //danh sach
            StreamBuilder (
                stream: stream,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator()
                    );
                  } else if(snapshot.hasError) {
                    return const Center(
                      child: Text('L???i'),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Kh??ng c?? d??? li???u'),
                    );
                  } else {
                    final documents = snapshot.data!.docs;
                    int total = snapshot.data!.docs.length;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: total,
                        itemBuilder: (context, index) {
                          if (documents[index]['uid'] == uid) {
                            return ListCard(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListScreen(
                                              listId: documents[index]['listId'],
                                              listTitle: documents[index]['listName'],
                                              color: headColor,
                                            )
                                    )
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Xo?? danh s??ch'),
                                      content: const Text('B???n ch???c ch??a?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore
                                                .instance
                                                .collection('lists')
                                                .doc(snapshot.data!.docs[index].id)
                                                .delete();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).clearSnackBars();
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xo?? th??nh c??ng')));
                                          },
                                          child: const Text('Xo??', style: TextStyle(color: Colors.red),),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Hu???', style: TextStyle(color: Colors.blue),),
                                        ),
                                      ],
                                    )
                                );
                              },
                              color: headColor,
                              listTitle: documents[index]['listName'],
                              listId: documents[index]['listId'],
                            );
                          } else {
                            return Container();
                          }
                        });
                  }
                }
            ),
            const Divider(
              color: Colors.black38,
            ),
            //huong dan su dung
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DraggableScrollableSheet(
                          maxChildSize: 0.9,
                          builder: (context, scrollController) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.white,
                              child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20,),
                                      Center(child: Text('H?????ng d???n s??? d???ng', style: TextStyle(fontSize: 30, color: headColor),),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Th??m todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nh???n n??t th??m ??? d?????i ????y m??n h??nh, h??? th???ng s??? pop up h???i tho???i th??m, b???n c???n nh???p ti??u ????? todo th?? m???i g???i ???????c.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('S???a todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nh???n todo b???n mu???n s???a, h??? th???ng s??? chuy???n sang trang s???a todo, sau khi ch???nh s???a xong b???n nh???n icon l??u ??? g??c tr??n m??n h??nh. L??u ?? n???u b???n ????? tr???ng gi?? tr??? ng??y th?? h??? th???ng s??? l??u gi?? tr??? c???a ng??y h??m nay', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Xo?? todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('K??o t??? ph???i sang tr??i s??? xu???t hi???n n??t xo??, b???n nh???n n??t xo?? v?? x??c nh???n xo?? todo.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Th??m danh s??ch:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nh???n menu g??c tr??n m??n h??nh, nh???n th??m danh s??ch m???i, m??n h??nh s??? xu???t hi???n h???p tho???i, b???n ph???i nh???p ti??u ????? c???a danh s??ch. Sau khi nh???p xong nh???n n??t th??m ????? th??m v??o danh s??ch.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Xo?? danh s??ch:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nh???n gi??? danh s??ch b???n mu???n xo??, m???t h???p tho???i s??? xu???t hi???n tr??n m??n h??nh b???n ????? x??c nh???n xo?? danh s??ch. Nh???n xo?? ????? xo?? danh s??ch', style: TextStyle(fontSize: 20),),

                                    ],
                                  )
                              ),
                            );
                          }
                      );
                    }
                );
              },
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.black54, size: iconSize,),
                      const SizedBox(width: 10,),
                      Text('H?????ng d???n s??? d???ng', style: TextStyle(fontSize: textSize),),
                    ],
                  )
              ),
            ),
          ],
        )
      ),
      appBar: AppBar(
        title: Text(headtext),
        backgroundColor: headColor,
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: index2,
            children: indexedList
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        disabledElevation: 20,
        backgroundColor: headColor,
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
                children:  [
                  //nut chon thu
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextField(
                      controller: txtTodoHead,
                      decoration: const InputDecoration(
                          hintText: 'Nh???p ti??u ????? todo'
                      ),
                    ),
                  ),
                  //nut chon thoi gian (nhac luc)
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
                                    backgroundColor: MaterialStateProperty.all(headColor),
                                    fixedSize: const MaterialStatePropertyAll<Size>(
                                        Size(100, 10)
                                    ),
                                  ),
                                  child: Text(
                                      day == null
                                          ? 'Ch???n th???'
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
                                          time = 'Nh???c l??c';
                                        }
                                        else {
                                          time = '${value?.hour}:${value?.minute}';
                                        }
                                      });
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(headColor),
                                    fixedSize: const MaterialStatePropertyAll<Size>(
                                        Size(100, 10)
                                    ),
                                  ),
                                  child: Text(
                                      time == null
                                          ? 'Nh???c l??c'
                                          : time!
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
                  //nut gui todo
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
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('H??y nh???p ti??u ????? todo')));
                                  }
                                  else {
                                    day ??= DateTime.now();
                                    final Todo event1 = Todo(
                                      uid: FirebaseAuth.instance.currentUser!.uid,
                                      title: txtTodoHead.text,
                                      time: time.toString(),
                                      day: day,
                                      content: '',
                                      star: star,
                                      done: false,
                                    );
                                    createTodo(event1);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Th??m todo th??nh c??ng')));
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(headColor),
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