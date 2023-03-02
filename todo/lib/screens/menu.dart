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
                        return const Center(child: Text('Đã xảy ra sự cố'),);
                      } else if(!snapshot.hasData) {
                        return const Center(child: Text('Không có dữ liệu'),);
                      } else {
                        final user = snapshot.data;
                        return user == null
                            ? const Center(child: Text('Đã xảy ra sự cố'),)
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
                        'Chỉnh sửa',
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
                  headtext = 'Hôm nay';
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
                        'Hôm nay',
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
                  headtext = 'Sắp tới';
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
                        'Sắp tới',
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
                  headtext = 'Quan trọng';
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
                        'Quan trọng',
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
                  headtext = 'Hoàn thành';
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
                        'Hoàn thành',
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
                  headtext = 'Quá hạn';
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
                        'Quá hạn',
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
                      title: const Text('Thêm danh sách'),
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hãy nhập tiêu đề list')));
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
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm list thành công')));
                            }
                          },
                          child: Text('Thêm', style: TextStyle(color: headColor),),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Huỷ', style: TextStyle(color: headColor),),
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
                      Text('Thêm danh sách mới', style: TextStyle(fontSize: textSize),),
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
                                      title: const Text('Xoá danh sách'),
                                      content: const Text('Bạn chắc chưa?'),
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
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Xoá thành công')));
                                          },
                                          child: const Text('Xoá', style: TextStyle(color: Colors.red),),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Huỷ', style: TextStyle(color: Colors.blue),),
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
                                      Center(child: Text('Hướng dẫn sử dụng', style: TextStyle(fontSize: 30, color: headColor),),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Thêm todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nhấn nút thêm ở dưới đáy màn hình, hệ thống sẽ pop up hội thoại thêm, bạn cần nhập tiêu đề todo thì mới gửi được.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Sửa todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nhấn todo bạn muốn sửa, hệ thống sẽ chuyển sang trang sửa todo, sau khi chỉnh sửa xong bạn nhấn icon lưu ở góc trên màn hình. Lưu ý nếu bạn để trống giá trị ngày thì hệ thống sẽ lưu giá trị của ngày hôm nay', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Xoá todo:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Kéo từ phải sang trái sẽ xuất hiện nút xoá, bạn nhấn nút xoá và xác nhận xoá todo.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Thêm danh sách:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nhấn menu góc trên màn hình, nhấn thêm danh sách mới, màn hình sẽ xuất hiện hộp thoại, bạn phải nhập tiêu đề của danh sách. Sau khi nhập xong nhấn nút thêm để thêm vào danh sách.', style: TextStyle(fontSize: 20),),
                                      const SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Xoá danh sách:', style: TextStyle(fontSize: 23, color: headColor), textAlign: TextAlign.start,),
                                      ),
                                      const Text('Nhấn giữ danh sách bạn muốn xoá, một hộp thoại sẽ xuất hiện trên màn hình bạn để xác nhận xoá danh sách. Nhấn xoá để xoá danh sách', style: TextStyle(fontSize: 20),),

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
                      Text('Hướng dẫn sử dụng', style: TextStyle(fontSize: textSize),),
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
                          hintText: 'Nhập tiêu đề todo'
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
                                          time = 'Nhắc lúc';
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
                                          ? 'Nhắc lúc'
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
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hãy nhập tiêu đề todo')));
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
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thêm todo thành công')));
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