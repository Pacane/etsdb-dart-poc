class WatchGroup {
}

class Database {
  final String name;
  final String path;
  final List<WatchGroup> watchGroups = <WatchGroup> [];

  Database(this.name, this.path);
}
