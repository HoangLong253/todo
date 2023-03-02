class Todo{
  String? uid;
  String? title;
  DateTime? day;
  String? time;
  String? content;
  bool? star;
  bool? done;

  Todo({
    this.uid,
    this.title,
    this.day,
    this.time,
    this.content,
    this.star,
    this.done
  });

  Map<String, dynamic> toJSON() => {
    'uid': uid,
    'title': title,
    'time': time,
    'day': day,
    'content': content,
    'star': star,
    'done': done,
  };

  static Todo fromJSON(Map<String, dynamic> json) => Todo(
    uid: json['id'],
    title: json['title'],
    time: json['time'],
    day: json['day'],
    content: json['content'],
    star: json['star'],
    done: json['done'],
  );
}