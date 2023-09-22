import 'package:day_tracker_graduation/models/task_item_model.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../router/app_router.dart';
import '../../../utils/svgs/svgs.dart';
import '../../../widgets/dialog_widget.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({
    super.key,
  });

  @override
  State<TaskListWidget> createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  late TaskProvider provider;
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, x) {
      provider = taskProvider;
      return Container(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            children: [
              buildAddTaskBtn(context, AddTo.first),
              buildList(),
              buildAddTaskBtn(context, AddTo.last)
            ],
          ));
    });
  }

  ReorderableListView buildList() {
    return ReorderableListView(
        shrinkWrap: true,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final todo = provider.currentTodos.removeAt(oldIndex);
            provider.currentTodos.insert(newIndex, todo);
          });
        },
        children: provider.currentTodos
            .asMap()
            .entries
            .map((entry) => taskItem(entry))
            .toList());
  }

  Widget taskItem(MapEntry<int, TaskItemModel> entry) {
    // Widget taskItem(MapEntry<int, String> entry) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          onTap: () {
            editTodo(entry.value, entry.key);
          },
          title: Text(
            entry.value.content,
            // entry.value,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.black),
          ),
          leading: svgDrag,
          horizontalTitleGap: 0,
          trailing: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                provider.currentTodos.removeAt(entry.key);
              });
            },
          ),
        ),
      ),
    );
  }

  SizedBox buildAddTaskBtn(BuildContext context, AddTo index) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
          onPressed: () => onAddBtnPressed(index),
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          icon: CircleAvatar(
            radius: 11.r,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          label: Text(
            'Add Task',
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: const Color(0x80707070)),
          )),
    );
  }

  editTodo(TaskItemModel task, int index) {
    showDialog(
        context: context,
        builder: (ctx) {
          return DialogWidget(
              dialogType: DialogType.editTask,
              entryType: 'task',
              content: task.content,
              onOkPressed: (value) {
                AppRouter.router.pop();

                if (value == task.content) {
                  AppRouter.router.pop();
                } else {
                  if (value.isEmpty) {
                    setState(() {
                      provider.currentTodos.removeAt(index);
                    });
                  } else {
                    provider.currentTodos[index].content = value;
                    setState(() {});
                  }
                }
              });
        });
  }

  onAddBtnPressed(AddTo index) {
    showDialog(
        context: context,
        builder: (ctx) {
          return DialogWidget(
              dialogType: DialogType.addTask,
              entryType: 'task',
              onNextPressed: (value) {
                AppRouter.router.pop();
                if (value.isNotEmpty) {
                  // provider.addTodo(value);
                  provider.addTodo(TaskItemModel(content: value), index);
                }
                onAddBtnPressed(index);
              },
              onOkPressed: (value) {
                AppRouter.router.pop();

                if (value.isNotEmpty) {
                  // provider.addTodo(value);
                  provider.addTodo(TaskItemModel(content: value), index);
                }
              });
        });
  }
}
