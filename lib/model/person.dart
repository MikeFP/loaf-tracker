import 'loan.dart';

class Person {
  String name;
  List<Loan> loans;

  Person({this.name, this.loans}) {
    if (loans == null) loans = [];
  }

  double get totalOwned => loans.fold<double>(0, (t, loan) => t + loan.amount);
}