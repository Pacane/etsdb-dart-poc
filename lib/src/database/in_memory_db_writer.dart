import 'dart:async';
import 'db_writer.dart';
import 'package:dslink/common.dart';

class InMemoryDbWriter extends DbWriter {
  Map<String, List<ValueUpdate>> updates = <String, List<ValueUpdate>>{};

  @override
  Future<Null> writeData(String path, ValueUpdate update) async {
    updates.putIfAbsent(path, () => <ValueUpdate>[]);
    updates[path].add(update);
  }
}
