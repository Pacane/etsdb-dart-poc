import 'dart:async';

import 'package:dslink/common.dart';

abstract class DbWriter {
  Future<Null> writeData(String path, ValueUpdate update);
}
