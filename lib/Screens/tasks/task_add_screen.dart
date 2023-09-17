import 'package:day_tracker_graduation/Screens/tasks/task_home_screen.dart';
import 'package:day_tracker_graduation/models/task_item_model.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:day_tracker_graduation/provider/auth_provider.dart';
import 'package:day_tracker_graduation/Screens/notes/widgets/appbar_textfield.dart';
import 'package:day_tracker_graduation/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../../widgets/appbar_widget.dart';
import 'widgets/task_list_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String? title;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TaskProvider>(
      builder: (context, authProvider, taskProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            onCheckPressed(taskProvider);
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppbarWidget(
                titlePlace: Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 18.r,
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
                        onPressed: () => onCheckPressed(taskProvider),
                        icon: const Icon(
                          Icons.check,
                          size: 18,
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

  onCheckPressed(TaskProvider taskProvider) {
    if (taskProvider.currentTodos.isNotEmpty) {
      taskProvider.addTask(
          task: TaskModel(
              id: DateTime.now().toString(),
              date: DateTime.now(),
              title: title ?? '',
              isLocked: false,
              items: taskProvider.currentTodos
                  .map((todo) => TaskItemModel(content: todo))
                  .toList()));
    }

    AppRouter.router.pushWithReplacementFunction(const TaskHomeScreen());
  }

  void onBackButtonPressed() {
    AppRouter.router.pushWithReplacementFunction(const TaskHomeScreen());
  }
}
