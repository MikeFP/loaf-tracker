import 'package:cash_loaf/model/loan.dart';
import 'package:cash_loaf/model/person.dart';

class LoanService {
  static var testLoans = [
    Person(name: 'Fulano', loans: [
      Loan(amount: 15, description: 'Cream Cheese'),
      Loan(amount: 85, description: 'Ventilador'),
    ]),
    Person(name: 'Beltrano', loans: [
      Loan(amount: 150, description: 'Academia'),
    ]),
    Person(name: 'Cicrano', loans: [
      Loan(amount: 4100, description: 'Empréstimo'),
    ]),
  ];
  static Future<List<Person>> getAllLoans() async {
    return testLoans;
  }
}
