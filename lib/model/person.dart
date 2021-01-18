import 'loan.dart';

class Person {
  int id;
  String name;
  List<Loan> loans;

  Person({this.id, this.name, this.loans}) {
    if (loans == null) loans = [];
  }

  double get totalOwned => loans.fold<double>(0, (t, loan) => t + loan.amount);
}