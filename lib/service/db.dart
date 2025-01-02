import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sandbox/db/db.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close(); // データベースを閉じる
  });
  return db;
});
