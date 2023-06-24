import 'package:intl/intl.dart';

class NoteModel {
  NoteModel(
      {required this.id,
      required this.content,
      required this.date,
      required this.title,
      this.password = ''});

  final int id;
  final String content;
  final String date;
  final String title;
  final String password;
  get isLocked {
    bool isLocked = password == '' ? false : true;
    return isLocked;
  }

  toMap() {
    return {
      'content': content,
      'date': DateFormat('MMMM d, y. EEE. hh:mm a')
          .format(DateTime.now()), //February 11, 2021. Thu. 03:30 PM
      'isLocked': isLocked ? 1 : 0, //February 11, 2022. Wed. 6:17 PM
      'title': title,
      'password': password,
    };
  }

  NoteModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map['content'],
        date = map['date'],
        title = map['title'],
        password = map['password'];
}
