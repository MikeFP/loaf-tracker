import 'package:loaf_tracker/model/money_source.dart';
import 'package:loaf_tracker/model/user.dart';
import 'package:sqflite/sqflite.dart';

import '../getit.dart';
import 'database_service.dart';
import 'loan_service.dart';

class UserService {
  static var testUser = User(sources: [
    MoneySource(name: 'Nubank', balance: 100),
    MoneySource(name: 'Inter', balance: 50),
    MoneySource(name: 'PicPay', balance: 440),
  ]);
  static Future<MoneySource> addSource(User user, MoneySource source) async {
    final Database db = await getIt<DatabaseService>().database;
    source.id = await db.rawInsert(
        'INSERT INTO money_source(name, balance, user_id) VALUES (?,?,?)',
        [source.name, source.balance, user.id]);
    return source;
  }

  static Future<User> createUser(User user) async {
    final Database db = await getIt<DatabaseService>().database;
    return await db.transaction((txn) async {
      user.id = await txn
          .rawInsert('INSERT INTO person(name) VALUES (?)', [user.name]);

      for (var source in user.sources) {
        source.id = await txn.rawInsert(
          'INSERT INTO money_source(name, balance, user_id) VALUES (?,?,?)',
          [
            source.name,
            source.balance,
            user.id,
          ],
        );
      }
      return user;
    });
  }

  static Future<User> getUser(int id) async {
    final Database db = await getIt<DatabaseService>().database;
    var row =
        (await db.rawQuery('SELECT * FROM person WHERE id = ?', [id])).first;
    var sources = (await db
            .rawQuery('SELECT * FROM money_source WHERE user_id = ?', [id]))
        .map((row) => MoneySource(
            id: row['id'], balance: row['balance'], name: row['name']))
        .toList();

    var loaners = await LoanService.getAllLoaners();
    return User(
        id: row['id'], name: row['name'], loaners: loaners, sources: sources);
  }

  static Future<User> saveUser(User user) async {
    final Database db = await getIt<DatabaseService>().database;
    return await db.transaction((txn) async {
      for (var source in user.sources) {
        if (source.id == null) {
          source.id = await txn.rawInsert(
            'INSERT INTO money_source(name, balance, user_id) VALUES (?,?,?)',
            [
              source.name,
              source.balance,
              user.id,
            ],
          );
        } else {
          await txn.rawUpdate(
            'UPDATE money_source SET balance = ?, name = ? WHERE id = ?',
            [source.balance, source.name, source.id],
          );
        }
      }
      return user;
    });
  }

  static Future<User> deleteSource(User user, MoneySource source) async {
    final Database db = await getIt<DatabaseService>().database;
    await db.rawQuery('DELETE FROM money_source WHERE id = ?', [source.id]);
    user.sources.removeAt(user.sources.indexOf(source));
    return user;
  }
}
