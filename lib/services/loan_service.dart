import 'package:cash_loaf/model/loan.dart';
import 'package:cash_loaf/model/person.dart';

class LoanService {
  static var testLoans = [
    Person(name: 'Fulano', loans: [
      Loan(amount: 100),
    ]),
    Person(name: 'Beltrano', loans: [
      Loan(amount: 150),
    ]),
    Person(name: 'Cicrano', loans: [
      Loan(amount: 4100),
    ]),
  ];
  static Future<List<Person>> getAllLoans() async {
    return testLoans;
  }
}
