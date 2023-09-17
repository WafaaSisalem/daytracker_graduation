import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../utils/svgs/svgs.dart';
import '../../../widgets/no_entries_widget.dart';
import '../widgets/task_widget.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, taskProvider, x) {
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
                      context: context,
                      index: index,
                      taskProvider: taskProvider);
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: 15.h,
                ),
                itemCount: taskProvider.allTasks.length,
              ),
            );
    });
  }

  TaskWidget buildItem(
      {required context,
      required int index,
      required TaskProvider taskProvider}) {
    taskProvider.selectedFlag[index] =
        taskProvider.selectedFlag[index] ?? false;
    bool isSelected = taskProvider.selectedFlag[index]!;

    return TaskWidget(
        isSelected: isSelected,
        isSelectionMode: taskProvider.isSelectionMode,
        onLongPress: () {
          onLongPress(isSelected, index, taskProvider);
        },
        task: taskProvider.allTasks[index],
        onTaskTap: () {
          onTaskTap(isSelected, index, taskProvider);
        },
        onPasswordIconTap: () {},
        onDeleteIconTap: () {});
  }

  void onLongPress(bool isSelected, int index, TaskProvider taskProvider) {
    setState(() {
      taskProvider.selectedFlag[index] = !isSelected;
      taskProvider.setSelectionMode();
    });
  }

  void onTaskTap(bool isSelected, int index, TaskProvider taskProvider) {
    // if (taskProvider.isSelectionMode) {
    //   setState(() {
    //     taskProvider.selectedFlag[index] = !isSelected;
    //     taskProvider.setSelectionMode();
    //   });
    // } else {
    //   if (taskProvider.allTasks[index].isLocked) {
    //     showDialog(
    //         context: context,
    //         builder: (context) => DialogWidget(
    //             dialogType: DialogType.password,
    //             entryType: 'task',
    //             onOkPressed: (value) {
    //               if (value.isEmpty) {
    //                 showToast('Password can not be empty!', context: context);
    //               } else {
    //                 if (taskProvider.userModel!.masterPassword == value) {
    //                   AppRouter.router.pop();
    //                   AppRouter.router
    //                       .pushWithReplacementFunction(NoteHandlingScreen(
    //                     type: NoteHandlingType.display,
    //                     note: widget.notes[index],
    //                   ));
    //                 } else {
    //                   showToast('Wrong Password!',
    //                       context: context, position: StyledToastPosition.top);
    //                 }
    //               }
    //             }));
    //   } else {
    //     AppRouter.router.pushWithReplacementFunction(NoteHandlingScreen(
    //       type: NoteHandlingType.display,
    //       note: widget.notes[index],
    //     ));
    //   }
    // }
  }
}
