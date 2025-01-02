import 'package:drift/drift.dart';

@DataClassName('Task')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().withLength(min: 1, max: 100)();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}
