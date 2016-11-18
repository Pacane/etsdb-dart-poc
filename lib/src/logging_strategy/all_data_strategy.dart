import '../database/db_writer.dart';
import 'dart:async';
import 'data_requester.dart';

import 'package:dslink/common.dart';

class AllDataStrategy {
  final DbWriter dbWriter;
  final DataRequester dataRequester;
  final Set<String> watchedPaths = new Set<String>();
  final Set<String> subscribedPaths = new Set<String>();

  AllDataStrategy(this.dbWriter, this.dataRequester);

  Future<Null> logPaths(List<String> pathsToWatch) async {
    watchedPaths.addAll(pathsToWatch);

    watchedPaths
        .where((String path) => !subscribedPaths.contains(path))
        .forEach((String path) {
      subscribedPaths.add(path);
      dataRequester
          .subscribe(path)
          .listen((ValueUpdate update) => dbWriter.writeData(path, update));
    });
  }

  Future<Null> stopLogging() async {
    for (var path in watchedPaths) {
      await dataRequester.unsubscribe(path);
    }
    subscribedPaths.clear();
  }
}
