import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../../router/app_router.dart';
import '../../../utils/constants.dart';
import '../../../utils/svgs/svgs.dart';
import '../../../widgets/dialog_widget.dart';
import '../../../widgets/no_entries_widget.dart';
import '../../master_password_screen.dart';
import '../task_display_screen.dart';
import '../widgets/task_widget.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  late TaskProvider taskProvider;
  late AuthProvider authProvider;
  @override
  Widget build(BuildContext context) {
    return Consumer2<TaskProvider, AuthProvider>(
        builder: (context, taskProvider, authProvider, x) {
      this.taskProvider = taskProvider;
      this.authProvider = authProvider;
      return taskProvider.allTasks.isEmpty
          ? Center(
              child: NoEntriesWidget(
                image: svgNoTask,
                text: 'No Task entries',
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return buildItem(
                    index: index,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 15.h,
                ),
                itemCount: taskProvider.allTasks.length,
              ),
            );
    });
  }

  TaskWidget buildItem({
    required int index,
  }) {
    // taskProvider.selectedFlag[index] =
    //     taskProvider.selectedFlag[index] ?? false;
    bool isSelected = taskProvider.selectedFlag[index]!;

    return TaskWidget(
        isSelected: isSelected,
        isSelectionMode: taskProvider.isSelectionMode,
        onLongPress: () {
          onLongPress(isSelected, index);
        },
        task: taskProvider.allTasks[index],
        onTaskTap: () {
          onTaskTap(isSelected, index);
        },
        onPasswordIconTap: () {
          onPassword(index);
        },
        onDeleteIconTap: () {
          onDelete(index);
        });
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      taskProvider.selectedFlag[index] = !isSelected;
      taskProvider.setSelectionMode();
    });
  }

  void onTaskTap(bool isSelected, int index) {
    if (taskProvider.isSelectionMode) {
      setState(() {
        taskProvider.selectedFlag[index] = !isSelected;
        taskProvider.setSelectionMode();
      });
    } else {
      if (taskProvider.allTasks[index].isLocked) {
        passwordDialog(whenMatch: () {
          AppRouter.router.pushWithReplacementFunction(TaskDisplayScreen(
            task: taskProvider.allTasks[index],
          ));
        });
      } else {
        AppRouter.router.pushWithReplacementFunction(
            TaskDisplayScreen(task: taskProvider.allTasks[index]));
      }
    }
  }

  Future<dynamic> passwordDialog({required Function() whenMatch}) {
    return showDialog(
        context: context,
        builder: (context) => DialogWidget(
            dialogType: DialogType.password,
            entryType: 'task',
            onOkPressed: (value) {
              if (value.isEmpty) {
                showToast('Password can not be empty!', context: context);
              } else {
                // if (taskProvider.userModel!.masterPassword == value)
                if (authProvider.userModel!.masterPassword == value) {
                  AppRouter.router.pop();
                  whenMatch();
                } else {
                  showToast('Wrong Password!',
                      context: context, position: StyledToastPosition.top);
                }
              }
            }));
  }

  void onPassword(index) {
    if (authProvider.userModel!.masterPassword.isEmpty) {
      AppRouter.router.pushNamedFunction(
          MasterPassScreen.routeName, [taskProvider.allTasks[index]]);
    } else {
      passwordDialog(whenMatch: () {
        if (taskProvider.allTasks[index].isLocked) {
          taskProvider.updateTask(TaskModel.fromMap({
            ...taskProvider.allTasks[index].toMap(),
            Constants.isLockedKey: 0,
          }));
        } else {
          taskProvider.updateTask(TaskModel.fromMap({
            ...taskProvider.allTasks[index].toMap(),
            Constants.isLockedKey: 1,
          }));
        }
      });
    }
  }

  void onDelete(int index) {
    if (taskProvider.allTasks[index].isLocked) {
      passwordDialog(whenMatch: () {
        deleteDialog(index);
      });
    } else {
      deleteDialog(index);
    }
  }

  Future<dynamic> deleteDialog(int index) {
    return showDialog(
        context: context,
        builder: (context) => DialogWidget(
            dialogType: DialogType.delete,
            entryType: 'task',
            onOkPressed: (value) {
              taskProvider.deleteTask(taskId: taskProvider.allTasks[index].id);
              AppRouter.router.pop();
            }));
  }
}
