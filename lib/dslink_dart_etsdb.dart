export 'src/database/db_writer.dart';
export 'src/logging_strategy/all_data_strategy.dart';
export 'src/logging_strategy/data_requester.dart';

class LoggingType {
  static LoggingType allData = const LoggingType._();

  const LoggingType._();
}

class WatchGroup {
  final List<Watch> watches = <Watch>[];

  LoggingType get loggingType => LoggingType.allData;
}

class Watch {
  final String pathToWatch;

  Watch(this.pathToWatch);
}

class Database {
  final String name;
  final String path;
  final List<WatchGroup> watchGroups = <WatchGroup>[];

  Database(this.name, this.path);
}

