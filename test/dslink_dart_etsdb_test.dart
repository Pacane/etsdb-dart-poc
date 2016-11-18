// Copyright (c) 2016, joel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:dslink_dart_etsdb/dslink_dart_etsdb.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:dslink/dslink.dart';

class MockDataRequester extends Mock implements DataRequester {}

class MockDbWriter extends Mock implements DbWriter {}

void main() {
  final String pathToWatch = '/data/path';

  test('watch group default logging strategy is allData', () {
    var sut = new WatchGroup();

    expect(sut.loggingType, LoggingType.allData);
  });

  group("AllData strategy", () {
    StreamController<ValueUpdate> fakeSubscription;
    DbWriter dbWriter;
    DataRequester dataRequester;
    AllDataStrategy sut;

    setUp(() {
      dbWriter = new MockDbWriter();

      fakeSubscription = new StreamController<ValueUpdate>(sync: true);
      dataRequester = new MockDataRequester();
      when(dataRequester.subscribe(pathToWatch))
          .thenReturn(fakeSubscription.stream);

      sut = new AllDataStrategy(dbWriter, dataRequester);
    });

    tearDown(() async {
      await fakeSubscription.close();
    });

    test('Subscribes to all data of a given path', () async {
      await sut.initialize(pathToWatch);

      verify(dataRequester.subscribe(pathToWatch));
    });

    test('Writes to database every value in the subscription', () async {
      final fakeData = new List.generate(10, (i) => new ValueUpdate(i));
      await sut.initialize(pathToWatch);

      fakeData.forEach((ValueUpdate u) => fakeSubscription.add(u));

      verifyInOrder(
          fakeData.map((ValueUpdate u) => dbWriter.writeData(pathToWatch, u)));
    });

    test('Unsubscribes to data stream when logging stops', () async {
      final fakeData = new List.generate(10, (i) => new ValueUpdate(i));
      await sut.initialize(pathToWatch);
      fakeData.forEach((ValueUpdate u) => fakeSubscription.add(u));

      await sut.stopLogging();

      verify(dataRequester.unsubscribe(pathToWatch));
    });
  });
}
