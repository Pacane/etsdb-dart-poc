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
