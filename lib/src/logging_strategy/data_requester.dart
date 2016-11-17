import 'dart:async';

import 'package:dslink/common.dart';
import 'package:dslink/requester.dart';
abstract class DataRequester {
  Stream<ValueUpdate> subscribe(String path);
}

class DSLinkDataRequester extends DataRequester {
  final Requester requester;

  DSLinkDataRequester(this.requester);

  @override
  Stream<ValueUpdate> subscribe(String path) {
    var controller = new StreamController<ValueUpdate>();

    requester.subscribe(path, (ValueUpdate u) => controller.add(u));

    return controller.stream;
  }
}
