import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker_graduation/models/task_item_model.dart';
import 'package:day_tracker_graduation/models/task_model.dart';
import 'package:flutter/material.dart';

import '../services/firestore_helper.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> allTasks = [];
  bool isSelectionMode = false;
  Map<int, bool> selectedFlag = {};
  List<TaskItemModel> currentTodos = [];

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

  void setSelectedFlags() {
    selectedFlag = {};
    for (int i = 0; i < allTasks.length; i++) {
      selectedFlag[i] = false;
    }
  }

  addTodo(TaskItemModel todo) {
    currentTodos.insert(0, todo);
    notifyListeners();
  }

  setCurrentTodos(List<TaskItemModel> todos) {
    currentTodos = todos;
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
    setSelectedFlags();
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
    selectedFlag.forEach((key, value) async {
      if (value) {
        // deleteTask(taskId: allTasks[key].id);
        await FirestoreHelper.firestoreHelper
            .deleteTask(taskId: allTasks[key].id);
      }
    });
    // selectedFlag = {};
    isSelectionMode = false;
    getAllTasks();
  }

  void updateTodos(String id, List<TaskItemModel> items) async {
    if (items.isEmpty) {
      deleteTask(taskId: id);
    } else {
      await FirestoreHelper.firestoreHelper.updateTodos(id, items);
    }
  }
}
