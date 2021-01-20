import 'package:cash_loaf/services/loan_service.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService() {
    Future(() async {
      WidgetsFlutterBinding.ensureInitialized();
      _database =
          openDatabase(join(await getDatabasesPath(), 'cash_loaf_database.db'),
              onCreate: (db, version) {
        return Future.wait([
          db.execute(
            "CREATE TABLE person(id INTEGER PRIMARY KEY, name TEXT)",
          ),
          db.execute(
            "CREATE TABLE loan(id INTEGER PRIMARY KEY, description TEXT, amount REAL, date TEXT, person_id INTEGER NOT NULL, FOREIGN KEY (person_id) REFERENCES person (id))",
          ),
        ]);
      }, onOpen: (db) {
        return db.execute('DELETE FROM loan; DELETE FROM person;');
      }, version: 1);

      for(var loaner in LoanService.testLoans) {
        await LoanService.createLoaner(loaner);
      }
    });
  }

  Future<Database> _database;
  Future<Database> get database => _database;
}
