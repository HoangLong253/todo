class TodoList{
  String? listId;
  String? uid;
  String? title;
  DateTime? day;
  String? time;
  String? content;
  bool? star;
  bool? done;

  TodoList({
    this.listId,
    this.uid,
    this.title,
    this.day,
    this.time,
    this.content,
    this.star,
    this.done
  });

  Map<String, dynamic> toJSON() => {
    'listId': listId,
    'uid': uid,
    'title': title,
    'time': time,
    'day': day,
    'content': content,
    'star': star,
    'done': done,
  };

  static TodoList fromJSON(Map<String, dynamic> json) => TodoList(
    listId: json['listId'],
    uid: json['id'],
    title: json['title'],
    time: json['time'],
    day: json['day'],
    content: json['content'],
    star: json['star'],
    done: json['done'],
  );
}