import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/list.dart';
import '../models/todo.dart';
import '../models/todolist.dart';
import '../models/user.dart';

Future createUser(User1 us, uid) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

  final json = us.toJSON();
  await docUser.set(json);
}

Future createTodo(Todo ev1) async {
  final docTodo = FirebaseFirestore.instance.collection('cards').doc();

  final json = ev1.toJSON();
  await docTodo.set(json);
}

Future createTodoList(TodoList ev1, listId) async {
  final docList = FirebaseFirestore.instance.collection('lists').doc(listId).collection('todos').doc();

  final json = ev1.toJSON();
  await docList.set(json);
}

Future createList(ListObj lsts, listId) async {
  final docTodo = FirebaseFirestore.instance.collection('lists').doc(listId);
  final json = lsts.toJSON();

  await docTodo.set(json);
}

Future<User1> getUser(uid) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final snapshot = await docUser.get();

  return User1.fromJSON(snapshot.data()!);
}

Future<Todo> getTodo() async {
  final docTodo = FirebaseFirestore.instance.collection('todos').doc('e7D6pMUtSvl0qUm3bT4Y');
  final snapshot = await docTodo.get();

  return Todo.fromJSON(snapshot.data()!);
}

Future<ListObj> getList(listId) async {
  final docListObj = FirebaseFirestore.instance.collection('lists').doc(listId);
  final snapshot = await docListObj.get();

  return ListObj.fromJSON(snapshot.data()!);
}

Future<ListObj> getTodoList(listId) async {
  final docTodoList = FirebaseFirestore.instance.collection('lists').doc(listId).collection('todos').doc();
  final snapshot = await docTodoList.get();

  return ListObj.fromJSON(snapshot.data()!);
}

Stream<List<Todo>> getAllTodo() => FirebaseFirestore.instance
    .collection('todos')
    .snapshots()
    .map((snap) =>
    snap.docs.map((doc) => Todo.fromJSON(doc.data())).toList());

Stream<List<ListObj>> getAllList() => FirebaseFirestore.instance
    .collection('lists')
    .snapshots()
    .map((snap) =>
    snap.docs.map((doc) => ListObj.fromJSON(doc.data())).toList());