import 'package:day_tracker_graduation/Screens/choose_screen.dart';
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
  late TaskProvider taskProvider;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Consumer<TaskProvider>(builder: (context, taskProvider, x) {
      this.taskProvider = taskProvider;
      tasks = taskProvider.allTasks;
      return WillPopScope(
        onWillPop: () async {
          AppRouter.router
              .pushWithReplacementFunction(const ChooseCardScreen());
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppbarWidget(
              actions: [
                taskProvider.isSelectionMode
                    ? onSelectionModeWidget()
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
              taskProvider.currentTodos.clear();
              AppRouter.router
                  .pushWithReplacementFunction(const TaskAddScreen());
            })),
      );
    });
  }

  onSelectionModeWidget() {
    return IconButton(
      icon: SizedBox(
        width: 18,
        height: 18,
        child: svgWhiteDelete,
      ),
      onPressed: () {
        bool isLockedExist = false;
        Iterable<int> keys = taskProvider.selectedFlag.keys;
        for (int key in keys) {
          if (taskProvider.selectedFlag[key] == true) {
            if (taskProvider.allTasks[key].isLocked) {
              isLockedExist = true;
            }
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
                        deleteDialog();
                      } else {
                        showToast('Wrong Password!',
                            context: context,
                            position: StyledToastPosition.top);
                      }
                    }
                  }));
        } else {
          deleteDialog();
        }
      },
    );
  }

  Future<dynamic> deleteDialog() {
    return showDialog(
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
}
