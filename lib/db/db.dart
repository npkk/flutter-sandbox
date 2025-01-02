import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_sandbox/db/entity/task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Task>> getTasks() {
    return select(tasks).get();
  }

  Future<void> addTask(String content) {
    return into(tasks).insert(
      TasksCompanion(
        content: Value(content),
        completed: Value(false),
      ),
    );
  }

  Future<void> updateTask(Task task) {
    return update(tasks).replace(task);
  }

  Future<void> deleteTask(Task task) {
    return delete(tasks).delete(task);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
