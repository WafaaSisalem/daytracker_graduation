import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class NoteModel {
  NoteModel(
      {required this.id,
      required this.content,
      required this.date,
      required this.title,
      required this.isLocked});

  final String id;
  final String content;
  final DateTime date;
  final String title;
  final bool isLocked;

  get formatedDate {
    return DateFormat(Constants.dateFormat).format(date);
  }

  toMap() {
    return {
      Constants.idKey: id,
      Constants.contentKey: content == '' ? title : content,
      Constants.formatedDateKey:
          formatedDate, //February 11, 2021. Thu. 03:30 PM
      Constants.dateKey: date,
      Constants.isLockedKey: isLocked ? 1 : 0, //February 11, 2022. Wed. 6:17 PM
      Constants.titleKey: title == '' ? content : title,
    };
  }

  NoteModel.fromMap(map)
      : id = map[Constants.idKey],
        content = map[Constants.contentKey],
        title = map[Constants.titleKey],
        isLocked = map[Constants.isLockedKey] == 1 ? true : false,
        date = (map[Constants.dateKey] is Timestamp)
            ? (map[Constants.dateKey] as Timestamp).toDate()
            : map[Constants.dateKey];
}
