import 'dart:async';

import 'package:dslink/common.dart';
import 'package:dslink/requester.dart';

abstract class DataRequester {
  Stream<ValueUpdate> subscribe(String path);

  Future<Null> unsubscribe(String path);
}

class DSLinkDataRequester extends DataRequester {
  final Requester requester;
  StreamController<ValueUpdate> controller;

  DSLinkDataRequester(this.requester);

  @override
  Stream<ValueUpdate> subscribe(String path) {
    controller = new StreamController<ValueUpdate>();

    requester.subscribe(path, (ValueUpdate u) => controller.add(u));

    return controller.stream;
  }
  @override
  Future<Null> unsubscribe(String path) async {
    requester.unsubscribe(path, (ValueUpdate u) => path);
    await controller.close();
  }
}
