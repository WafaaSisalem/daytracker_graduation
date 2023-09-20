import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';
import 'task_item_model.dart';

class TaskModel extends Equatable {
  TaskModel(
      {required this.id,
      required this.date,
      required this.title,
      required this.isLocked,
      required this.items});

  final String id;
  final DateTime date;
  final String title;
  final bool isLocked;
  final List<dynamic> items; //as TaskItemModel

  get formatedDate {
    return DateFormat(Constants.dateFormat).format(date);
  }

  toMap() {
    return {
      Constants.idKey: id,
      Constants.formatedDateKey:
          formatedDate, //February 11, 2021. Thu. 03:30 PM
      Constants.dateKey: date,
      Constants.isLockedKey: isLocked ? 1 : 0, //February 11, 2022. Wed. 6:17 PM
      Constants.titleKey: title == '' ? formatedDate : title,
      Constants.itemsKey: items.map((item) => item.toMap()).toList(),
    };
  }

  TaskModel.fromMap(map)
      : id = map[Constants.idKey],
        title = map[Constants.titleKey],
        isLocked = map[Constants.isLockedKey] == 1 ? true : false,
        date = (map[Constants.dateKey] is Timestamp)
            ? (map[Constants.dateKey] as Timestamp).toDate()
            : map[Constants.dateKey],
        items = (map[Constants.itemsKey] as List)
            .map((mapItem) =>
                TaskItemModel.fromMap(mapItem as Map<String, dynamic>))
            .toList();

  @override
  List<Object?> get props => [title, items];
}
