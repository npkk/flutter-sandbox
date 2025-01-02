import 'package:flutter_sandbox/db/db.dart';
import 'package:flutter_sandbox/service/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final taskProvider =
    AsyncNotifierProvider<TaskNotifier, List<Task>>(TaskNotifier.new);

class TaskNotifier extends AsyncNotifier<List<Task>> {
  late final AppDatabase _db;
  late bool showCompleted;

  @override
  Future<List<Task>> build() async {
    _db = ref.read(databaseProvider);
    showCompleted = false;
    return _fetchTasks();
  }

  Future<List<Task>> _fetchTasks() async {
    return await (_db.select(_db.tasks)
          ..where((tbl) => tbl.completed.isIn([showCompleted, false])))
        .get();
  }

  Future<void> toggleShowCompleted(bool showCompleted_) async {
    showCompleted = showCompleted_;
    state = AsyncValue.data(await _fetchTasks());
  }

  Future<void> addTask(String content) async {
    await _db.addTask(content);
    state = AsyncValue.data(await _fetchTasks());
  }

  Future<void> completeTask(Task task) async {
    await _db.updateTask(task.copyWith(completed: true));
    state = AsyncValue.data(await _fetchTasks());
  }

  Future<void> deleteTask(Task task) async {
    await _db.deleteTask(task);
    state = AsyncValue.data(await _fetchTasks());
  }
}
