import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:day_tracker_graduation/widgets/back_home_widget.dart';
import 'package:day_tracker_graduation/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/fab_widget.dart';
import '../../utils/svgs/svgs.dart';
import 'task_add_screen.dart';
import 'tabs/task_tab.dart';

class TaskHomeScreen extends StatefulWidget {
  const TaskHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskHomeScreen> createState() => _TaskHomeScreenState();
}

class _TaskHomeScreenState extends State<TaskHomeScreen> {
  int currentIndex = 0;
  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<TaskProvider>(builder: (context, taskProvider, x) {
      tasks = taskProvider.allTasks;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppbarWidget(
            actions: [
              taskProvider.isSelectionMode
                  ? onSelectionModeWidget(taskProvider)
                  : const BackHomeMenuWidget()
            ],
            titlePlace: Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  'Home Page',
                  style: theme.textTheme.headline2,
                ),
              ],
            ),
          ),
          body: const TaskTab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FabWidget(onPressed: () {
            AppRouter.router.pushWithReplacementFunction(const AddTaskScreen());
          }));
    });
  }

  onSelectionModeWidget(TaskProvider taskProvider) {
    return IconButton(
      icon: svgWhiteDelete,
      onPressed: () {
        bool isLockedExist = false;
        Iterable<int> keys = taskProvider.selectedFlag.keys;
        for (int key in keys) {
          if (taskProvider.allTasks[key].isLocked) {
            isLockedExist = true;
          }
        }
        if (isLockedExist) {
          showDialog(
              context: context,
              builder: (context) => DialogWidget(
                  dialogType: DialogType.password,
                  entryType: 'task',
                  onOkPressed: (value) {
                    if (value.isEmpty) {
                      showToast('Password can not be empty!', context: context);
                    } else {
                      if (Provider.of<AuthProvider>(context, listen: false)
                              .userModel!
                              .masterPassword ==
                          value) {
                        AppRouter.router.pop();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogWidget(
                                  dialogType: DialogType.delete,
                                  entryType: 'note',
                                  onOkPressed: (value) {
                                    taskProvider.deleteSelectedTask();
                                    AppRouter.router.pop();
                                  });
                            });
                      } else {
                        showToast('Wrong Password!',
                            context: context,
                            position: StyledToastPosition.top);
                      }
                    }
                  }));
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return DialogWidget(
                    dialogType: DialogType.delete,
                    entryType: 'task',
                    onOkPressed: (value) {
                      taskProvider.deleteSelectedTask();
                      AppRouter.router.pop();
                    });
              });
        }
      },
    );
  }
}
