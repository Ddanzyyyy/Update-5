import 'package:flutter/foundation.dart';
import 'package:to_do_list_app/database_helper.dart';
import '../models/task.dart';

// providers/task_provider.dart
class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  
  // Ambil hanya tugas aktif (yang tidak dihapus)
  List<Task> get tasks => _tasks.where((task) => !task.isDeleted).toList();

  // Ambil hanya tugas yang berada di bin
  List<Task> get binTasks => _tasks.where((task) => task.isDeleted).toList();

  TaskProvider() {
    loadTasks();
  }

  get isDarkMode => null;

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    int newId = await DatabaseHelper().insertTask(task);
    task.id = newId;
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(int index, Task newTask) async {
    if (index >= 0 && index < _tasks.length) {
      final oldTask = _tasks[index];
      final updatedTask = newTask.copyWith(id: oldTask.id);
      
      await DatabaseHelper().updateTask(updatedTask);
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> moveToBin(Task task) async {
    if (task.id != null) {
      task.isDeleted = true;
      await DatabaseHelper().updateTask(task);
      notifyListeners();
    }
  }

  Future<void> restoreFromBin(Task task) async {
    if (task.id != null) {
      task.isDeleted = false;
      await DatabaseHelper().updateTask(task);
      notifyListeners();
    }
  }

  Future<void> deletePermanently(Task task) async {
    if (task.id != null) {
      await DatabaseHelper().deleteTask(task.id!);
      _tasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    } else {
      print("Error: task.id is null");
    }
  }

  Future<void> removeTask(Task task) async {
    if (task.id != null) {
      // Pindahkan tugas ke bin daripada menghapusnya
      await moveToBin(task);
    } else {
      print("Error: task.id is null");
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    if (task.id != null) {
      task.isCompleted = !task.isCompleted;
      await DatabaseHelper().updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
      notifyListeners();
    }
  }

  void toggleDarkMode() {}

  void clearBin() {}
}
