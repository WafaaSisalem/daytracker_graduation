import 'package:equatable/equatable.dart';

import '../utils/constants.dart';

class TaskItemModel extends Equatable {
  TaskItemModel({
    // required this.itemId,
    // required this.taskId,
    required this.content,
    this.done = false,
  });
  // int itemId;
  // String taskId;
  String content;
  bool done;
  Map<String, dynamic> toMap() {
    return {
      // Constants.itemIdKey: itemId,
      // Constants.taskIdKey: taskId,
      Constants.contentKey: content,
      Constants.doneKey: done,
    };
  }

  factory TaskItemModel.fromMap(Map<String, dynamic> map) {
    return TaskItemModel(
      // itemId: map[Constants.itemIdKey]?.toInt() ?? 0,
      // taskId: map[Constants.taskIdKey] ?? '',
      content: map[Constants.contentKey] ?? '',
      done: map[Constants.doneKey] ?? false,
    );
  }

  @override
  List<Object?> get props => [content];
}
