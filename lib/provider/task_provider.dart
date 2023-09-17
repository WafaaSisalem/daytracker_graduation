import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:flutter/material.dart';

import '../services/firestore_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> allTasks = [];
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  List<String> currentTodos = [];

  TaskProvider() {
    getAllTasks();
  }

  addTask({
    required TaskModel task,
  }) async {
    await FirestoreHelper.firestoreHelper.addTask(
      task: task,
    );
    getAllTasks();
  }

  addTodo(String todo) {
    currentTodos.insert(0, todo);
    notifyListeners();
  }

  deleteTask({required String taskId}) async {
    await FirestoreHelper.firestoreHelper.deleteTask(taskId: taskId);
    getAllTasks();
  }

  getAllTasks() async {
    allTasks.clear();
    currentTodos.clear();
    QuerySnapshot taskQuery =
        await FirestoreHelper.firestoreHelper.getAllTasks();
    allTasks = taskQuery.docs.map((task) => TaskModel.fromMap(task)).toList();
    notifyListeners();
  }

  void updateTask(TaskModel task) async {
    await FirestoreHelper.firestoreHelper.updateTask(task);
    getAllTasks();
  }

  TaskModel getTaskById(String? id) {
    return allTasks.where((element) => element.id == id).toList()[0];
  }

  void setSelectionMode() {
    isSelectionMode = selectedFlag.containsValue(true);
    notifyListeners();
  }

  void deleteSelectedTask() {
    selectedFlag.forEach((key, value) {
      if (value) {
        deleteTask(taskId: allTasks[key].id);
      }
    });
    selectedFlag = {};
    isSelectionMode = false;
  }
}
