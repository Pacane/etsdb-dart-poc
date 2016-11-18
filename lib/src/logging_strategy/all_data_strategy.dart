import '../database/db_writer.dart';
import 'dart:async';
import 'data_requester.dart';

import 'package:dslink/common.dart';

class AllDataStrategy {
  final DbWriter dbWriter;
  final DataRequester dataRequester;
  String watchedPath;

  AllDataStrategy(this.dbWriter, this.dataRequester);

  Future<Null> initialize(String pathToWatch) async {
    this.watchedPath = pathToWatch;

    dataRequester
        .subscribe(pathToWatch)
        .listen((ValueUpdate update) => dbWriter.writeData(pathToWatch, update));
  }

  Future<Null> stopLogging() async {
    await dataRequester.unsubscribe(watchedPath);
  }
}
