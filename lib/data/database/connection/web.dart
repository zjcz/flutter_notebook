import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

// Allows Drift to work in a web browser.
// See https://drift.simonbinder.eu/web/#prerequisites
class Connection {
  /// Obtains a database connection for running drift on the web.
  DatabaseConnection openConnection() {
    return DatabaseConnection.delayed(Future(() async {
      final db = await WasmDatabase.open(
        databaseName: 'flutter_notebook-app',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (db.missingFeatures.isNotEmpty) {
        debugPrint('Using ${db.chosenImplementation} due to unsupported '
            'browser features: ${db.missingFeatures}');
      }

      return db.resolvedExecutor;
    }));
  }

  static DatabaseConnection getDatabaseConnection() {
    // here we could instanciate a different connection class depending on the platform.
    // to keep things simple we will just have a single Connection class
    Connection c = Connection();
    return c.openConnection();
  }
}
