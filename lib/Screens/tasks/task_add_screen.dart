import 'package:day_tracker_graduation/Screens/tasks/task_home_screen.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/Screens/notes/widgets/appbar_textfield.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../widgets/appbar_widget.dart';
import '../../widgets/dialog_widget.dart';
import 'widgets/task_list_widget.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  String? title;
  late TaskProvider taskProvider;
  late AuthProvider authProvider;
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TaskProvider>(
      builder: (context, authProvider, taskProvider, child) {
        this.taskProvider = taskProvider;
        this.authProvider = authProvider;

        return WillPopScope(
          onWillPop: () async {
            onCheckPressed();
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppbarWidget(
                titlePlace: Row(children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 28,
                      color: Colors.white, //TODO: COLOR
                    ),
                    onPressed: () {
                      onBackButtonPressed();
                    },
                  ),
                  AppbarTextFieldWidget(
                      onChanged: (value) {
                        title = value;
                      },
                      hintText: 'Title',
                      autofocus: true,
                      text: title)
                ]),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () => onCheckPressed(),
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 28,
                          color: Colors.white, //TODO: COLOR
                        )),
                  ),
                ]),
            body: const TaskListWidget(),
          ),
        );
      },
    );
  }

  onCheckPressed() {
    if (taskProvider.currentTodos.isNotEmpty) {
      taskProvider.addTask(
          task: TaskModel(
              id: DateTime.now().toString(),
              date: DateTime.now(),
              title: title ?? '',
              isLocked: false,
              items: taskProvider.currentTodos));
    }

    AppRouter.router.pushWithReplacementFunction(const TaskHomeScreen());
  }

  void onBackButtonPressed() {
    if (taskProvider.currentTodos.isEmpty) {
      AppRouter.router.pushWithReplacementFunction(const TaskHomeScreen());
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return DialogWidget(
                dialogType: DialogType.discard,
                entryType: 'task',
                onOkPressed: (value) {
                  AppRouter.router.pop();
                  AppRouter.router
                      .pushWithReplacementFunction(const TaskHomeScreen());
                });
          });
    }
  }
}
