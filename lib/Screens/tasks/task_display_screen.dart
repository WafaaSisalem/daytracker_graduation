import 'dart:async';

import 'package:day_tracker_graduation/Screens/tasks/task_add_screen.dart';
import 'package:day_tracker_graduation/Screens/tasks/task_edit_screen.dart';
import 'package:day_tracker_graduation/Screens/tasks/task_home_screen.dart';
import 'package:day_tracker_graduation/models/task_item_model.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/svgs/svgs.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../master_password_screen.dart';

class TaskDisplayScreen extends StatefulWidget {
  const TaskDisplayScreen({super.key, required this.task});
  final TaskModel task;

  @override
  State<TaskDisplayScreen> createState() => _TaskDisplayScreenState();
}

class _TaskDisplayScreenState extends State<TaskDisplayScreen> {
  late AuthProvider authProvider;
  late TaskProvider taskProvider;
  late List<TaskItemModel> items;
  // Replace with your variable
  StreamController<bool> variableController = StreamController<bool>();
  Stream<bool>? variableStream;

  @override
  void initState() {
    super.initState();
    variableStream = variableController.stream;

    // Add a listener to the stream
    variableStream!.listen((value) {
      if (value == true) {
        AppRouter.router.pushWithReplacementFunction(TaskHomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, AuthProvider>(
        builder: (context, taskProvider, authProvider, x) {
      this.authProvider = authProvider;
      this.taskProvider = taskProvider;
      items = widget.task.items as List<TaskItemModel>;

      return WillPopScope(
        onWillPop: () => AppRouter.router
            .pushWithReplacementFunction(const TaskHomeScreen()),
        child: Scaffold(
          appBar: AppbarWidget(
              titlePlace: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 28,
                      color: Colors.white, //TODO: COLOR
                    ),
                    onPressed: () {
                      AppRouter.router
                          .pushWithReplacementFunction(const TaskHomeScreen());
                    },
                  ),
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.headline2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
              actions: [
                deleteIcon(),
                SizedBox(
                  width: 15.w,
                ),
                lockIcon(),
                SizedBox(
                  width: 15.w,
                ),
                editIcon(),
                SizedBox(
                  width: 30.w,
                ),
              ]),
          body: todoList(),
        ),
      );
    });
  }

  Container todoList() {
    return Container(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (BuildContext ctx, int index) {
          return listItem(index);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 10,
          );
        },
      ),
    );
  }

  InkWell editIcon() {
    return InkWell(
      // splashColor: Colors.transparent,
      child: SizedBox(
        width: 18,
        height: 18,
        child: svgEditIcon,
      ),
      onTap: () {
        taskProvider.setCurrentTodos(items);
        AppRouter.router.pushWithReplacementFunction(TaskEditScreen(
          task: widget.task,
        ));
      },
    );
  }

  InkWell lockIcon() {
    return InkWell(
      // splashColor: Colors.transparent,
      child: SizedBox(
        width: 18,
        height: 18,
        child: widget.task.isLocked ? svgWhiteUnlock : svgWhiteLock,
      ),
      onTap: () {
        if (authProvider.userModel!.masterPassword.isEmpty) {
          AppRouter.router.pushFunction(MasterPassScreen(item: widget.task));
        } else {
          passwordDialog(whenMatch: () {
            if (widget.task.isLocked) {
              taskProvider.updateTask(TaskModel.fromMap({
                ...widget.task.toMap(),
                Constants.isLockedKey: 0,
              }));
            } else {
              taskProvider.updateTask(TaskModel.fromMap({
                ...widget.task.toMap(),
                Constants.isLockedKey: 1,
              }));
            }
          });
        }
      },
    );
  }

  InkWell deleteIcon() {
    return InkWell(
      child: SizedBox(
        width: 18,
        height: 18,
        child: svgWhiteDelete,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return DialogWidget(
                  dialogType: DialogType.delete,
                  entryType: 'task',
                  onOkPressed: (value) {
                    taskProvider.deleteTask(taskId: widget.task.id);

                    AppRouter.router.pop();
                    AppRouter.router
                        .pushWithReplacementFunction(const TaskHomeScreen());
                  });
            });
      },
    );
  }

  listItem(int index) {
    TaskItemModel todoItem = items[index];
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 20),
        onTap: () {
          todoItem.done = !todoItem.done;
          taskProvider.updateTodos(widget.task.id, items);
          setState(() {});
        },
        title: Text(
          todoItem.content,
          style: Theme.of(context).textTheme.headline2!.copyWith(
              decoration: todoItem.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: todoItem.done ? const Color(0xffB5B5B5) : Colors.black),
        ),
        leading: !todoItem.done
            ? Icon(
                Icons.radio_button_off,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              )
            : Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
        horizontalTitleGap: 0,
        trailing: PopupMenuButton<int>(
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Copy to Clipboard'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Delete'),
              ),
            ];
          },
          onSelected: (int value) {
            if (value == 0) {
              Clipboard.setData(ClipboardData(text: todoItem.content));
            } else if (value == 1) {
              items.removeAt(index);
              taskProvider.updateTodos(widget.task.id, items);
              bool isEmpty = items.isEmpty;
              print(isEmpty);
              variableController.add(isEmpty);
              setState(() {});
            }
          },
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xffBB86FC),
          ),
        ),
      ),
    );
  }

  passwordDialog({required Function() whenMatch}) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return DialogWidget(
              dialogType: DialogType.password,
              entryType: 'task',
              onOkPressed: (value) {
                if (value.isEmpty) {
                  showToast('Password can not be empty!', context: context);
                } else {
                  if (authProvider.userModel!.masterPassword == value) {
                    AppRouter.router.pop();
                    whenMatch();
                  } else {
                    showToast('Wrong Password!',
                        context: context, position: StyledToastPosition.top);
                  }
                }
              });
        });
  }
}
