import 'package:loaf_tracker/model/loan.dart';
import 'package:loaf_tracker/model/person.dart';
import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import '../getit.dart';
import 'database_service.dart';

class LoanService {
  static var testLoans = [
    Person(name: 'Fulano', loans: [
      Loan(amount: 15, description: 'Cream Cheese', date: DateTime.now()),
      Loan(amount: 85, description: 'Ventilador', date: DateTime.now()),
    ]),
    Person(name: 'Beltrano', loans: [
      Loan(amount: 150, description: 'Academia', date: DateTime.now()),
    ]),
    Person(name: 'Cicrano', loans: [
      Loan(amount: 4100, description: 'Empréstimo', date: DateTime.now()),
    ]),
  ];
  static Future<List<Person>> getAllLoaners() async {
    final Database db = await getIt<DatabaseService>().database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT person.*, person.id as person_id, loan.*, loan.id as loan_id FROM person JOIN loan ON person.id = loan.person_id');

    var groupedMaps = groupBy(maps, (item) => item['person_id']);

    return groupedMaps.entries
        .map((item) => Person(
              id: item.key,
              name: item.value.first['name'],
              loans: item.value
                  .map((row) => Loan(
                        id: row['loan_id'],
                        description: row['description'],
                        date: DateTime.parse(row['date']),
                        amount: row['amount'],
                      ))
                  .toList(),
            ))
        .toList();
  }

  static Future<Person> createLoaner(Person loaner) async {
    final Database db = await getIt<DatabaseService>().database;

    return await db.transaction((txn) async {
      loaner.id = await txn
          .rawInsert('INSERT INTO person(name) VALUES(?)', [loaner.name]);

      for (var loan in loaner.loans) {
        if (loan.id == null) {
          loan.id = await txn.rawInsert(
            'INSERT INTO loan(person_id, description, amount, date) VALUES(?,?, ?, ?)',
            [
              loaner.id,
              loan.description,
              loan.amount,
              loan.date.toIso8601String()
            ],
          );
        } else {
          await txn.rawUpdate(
            'UPDATE loan SET description = ?, amount = ? WHERE id = ?',
            [
              loan.description,
              loan.amount,
              loan.id,
            ],
          );
        }
      }
      return loaner;
    });
  }

  static Future<List<Loan>> saveLoans(Person loaner) async {
    final Database db = await getIt<DatabaseService>().database;

    return await db.transaction((txn) async {
      for (var loan in loaner.loans) {
        if (loan.id == null) {
          loan.id = await txn.rawInsert(
            'INSERT INTO loan(person_id, description, amount, date) VALUES(?,?, ?, ?)',
            [
              loaner.id,
              loan.description,
              loan.amount,
              loan.date.toIso8601String()
            ],
          );
        } else {
          await txn.rawUpdate(
            'UPDATE loan SET description = ?, amount = ? WHERE id = ?',
            [
              loan.description,
              loan.amount,
              loan.id,
            ],
          );
        }
      }
      return loaner.loans;
    });
  }

  static Future<Person> payLoans(
      Person loaner, List<Loan> paidLoans, List<Loan> updatedLoans) async {
    final Database db = await getIt<DatabaseService>().database;

    await db.transaction((txn) async {
      for (var loan in paidLoans) {
        await txn.rawUpdate(
          'DELETE FROM loan WHERE id = ?',
          [loan.id],
        );
      }
      for (var loan in updatedLoans) {
        await txn.rawUpdate(
          'UPDATE loan SET amount = ? WHERE id = ?',
          [loan.amount, loan.id],
        );
      }
    });

    for (var loan in paidLoans) {
      loaner.loans.remove(loan);
    }
    for (var ul in updatedLoans) {
      loaner.loans.firstWhere((loan) => loan.id == ul.id).amount = ul.amount;
    }
    return loaner;
  }
}
