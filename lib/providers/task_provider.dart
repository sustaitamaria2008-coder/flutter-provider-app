import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  int get totalTasks => _tasks.length;

  int get completedTasks => _tasks.where((task) => task["done"] == true).length;

  int get pendingTasks => _tasks.where((task) => task["done"] == false).length;

  double get progress {
    if (_tasks.isEmpty) return 0;
    return completedTasks / totalTasks;
  }

  // CARGAR TAREAS
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("tasks");

    if (data != null) {
      final List decoded = jsonDecode(data);
      _tasks.clear();
      _tasks.addAll(decoded.map((e) => Map<String, dynamic>.from(e)).toList());
      notifyListeners();
    }
  }

  // GUARDAR TAREAS
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("tasks", jsonEncode(_tasks));
  }

  void addTask(String title, String priority) {
    _tasks.add({
      "title": title,
      "priority": priority,
      "done": false,
      "date": DateTime.now().toString(),
    });

    saveTasks();
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index]["done"] = !_tasks[index]["done"];

    saveTasks();
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);

    saveTasks();
    notifyListeners();
  }

  void editTask(int index, String newTitle, String newPriority) {
    _tasks[index]["title"] = newTitle;
    _tasks[index]["priority"] = newPriority;

    saveTasks();
    notifyListeners();
  }

  void clearAll() {
    _tasks.clear();

    saveTasks();
    notifyListeners();
  }
}
