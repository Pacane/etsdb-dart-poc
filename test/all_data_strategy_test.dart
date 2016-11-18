// Copyright (c) 2016, joel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:dslink_dart_etsdb/dslink_dart_etsdb.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:dslink/dslink.dart';
import 'mocks.dart';

DbWriter dbWriter;
DataRequester dataRequester;
AllDataStrategy sut;
List<String> paths = ['path1', 'path2'];
Map<String, StreamController<ValueUpdate>> fakeSubscriptions = {};
Map<String, List<ValueUpdate>> fakeData = {};

void main() {
  test('watch group default logging strategy is allData', () {
    var sut = new WatchGroup();

    expect(sut.loggingType, LoggingType.allData);
  });

  group('Multiple paths', () {
    setUp(() {
      dbWriter = new MockDbWriter();

      dataRequester = new MockDataRequester();

      stubSubscriptionsWithFakeData();

      sut = new AllDataStrategy(dbWriter, dataRequester);
    });

    tearDown(() async {
      for (var sub in fakeSubscriptions.values) {
        await sub.close();
      }

      fakeSubscriptions.clear();
      fakeData.clear();
    });

    test('Subscribes to all data of a given path', () async {
      await sut.logPaths(paths);

      for (var path in paths) {
        verify(dataRequester.subscribe(path));
      }
    });

    test('Writes to database every value in the subscription', () async {
      await sut.logPaths(paths);

      sendAllFakeData();

      for (var path in paths) {
        verifyInOrder(
            fakeData[path].map((ValueUpdate u) => dbWriter.writeData(path, u)));
      }
    });

    test('Unsubscribes from data stream when logging stops', () async {
      await sut.logPaths(paths);

      sendAllFakeData();

      await sut.stopLogging();

      for (var path in paths) {
        verify(dataRequester.unsubscribe(path));
      }
    });

    test('Strategy handles duplicate subscriptions', () async {
      await sut.logPaths(paths);
      await sut.logPaths(paths);
    });

    test('Strategy handles start/stop/start scenario', () async {
      await sut.logPaths(paths);

      await sut.stopLogging();

      stubSubscriptionsWithFakeData();

      await sut.logPaths(paths);
    });
  });
}

void stubSubscriptionsWithFakeData() {
  for (var path in paths) {
    fakeSubscriptions[path] = new StreamController(sync: true);
    fakeData[path] = new List.generate(10, (i) => new ValueUpdate(i));
    when(dataRequester.subscribe(path))
        .thenReturn(fakeSubscriptions[path].stream);
  }
}

void sendAllFakeData() {
  for (var path in paths) {
    for (var value in fakeData[path]) {
      fakeSubscriptions[path].add(value);
    }
  }
}
