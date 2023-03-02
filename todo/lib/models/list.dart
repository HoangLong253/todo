import 'todo.dart';

class ListObj{
  String? uid;
  String? listName;
  String? listId;

  ListObj({
    this.uid,
    this.listName,
    this.listId
  });

  Map<String, dynamic> toJSON() => {
    'uid': uid,
    'listName': listName,
    'listId': listId,
  };

  static ListObj fromJSON(Map<String, dynamic> json) => ListObj(
    uid: json['uid'],
    listName: json['listName'],
    listId: json['listId'],
  );
}

