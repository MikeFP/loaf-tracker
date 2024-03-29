import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'loan_service.dart';

class DatabaseService {
  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database =
        openDatabase(join(await getDatabasesPath(), 'loaf_tracker_database.db'),
            onCreate: (db, version) {
      return Future.wait([
        db.execute(
          "CREATE TABLE person(id INTEGER PRIMARY KEY, name TEXT)",
        ),
        db.execute(
          "CREATE TABLE loan(id INTEGER PRIMARY KEY, description TEXT, amount REAL, date TEXT, person_id INTEGER NOT NULL, FOREIGN KEY (person_id) REFERENCES person (id))",
        ),
        db.execute(
          "CREATE TABLE money_source(id INTEGER PRIMARY KEY, name TEXT, balance REAL, user_id INTEGER NOT NULL, FOREIGN KEY (user_id) REFERENCES person (id))",
        ),
      ]);
    }, onOpen: (db) {
      if (env['MOCK_DATA'] == 'true') {
        return db.execute('DELETE FROM loan; DELETE FROM money_source; DELETE FROM person;');
      }
    }, version: 1);

    if (env['MOCK_DATA'] == 'true') {
      for(var loaner in LoanService.testLoans) {
        await LoanService.createLoaner(loaner);
      }
    }
  }

  Future<Database> _database;
  Future<Database> get database => _database;
}
