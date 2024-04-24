import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

class Connection {
  final String _defaultDatabaseFilename = 'flutter_notebook.sqlite';

  LazyDatabase openConnection() {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, _defaultDatabaseFilename));

      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
        // Make sqlite3 pick a more suitable location for temporary files - the
        // one from the system may be inaccessible due to sandboxing.
        final cachebase = (await getTemporaryDirectory()).path;
        // We can't access /tmp on Android, which sqlite3 would try by default.
        // Explicitly tell it about the correct temporary directory.
        sqlite3.tempDirectory = cachebase;
      }

      return NativeDatabase.createInBackground(file);
    });
  }

  static LazyDatabase getDatabaseConnection() {
    // here we could instanciate a different connection class depending on the platform.
    // to keep things simple we will just have a single Connection class
    Connection c = Connection();
    return c.openConnection();
  }
}
