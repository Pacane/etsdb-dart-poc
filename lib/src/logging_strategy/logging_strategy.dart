import 'dart:async';

abstract class LoggingStrategy {
  Future<Null> logPaths(List<String> pathsToWatch);

  Future<Null> stopLogging();
}
