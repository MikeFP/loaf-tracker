import 'money_source.dart';
import 'person.dart';

class User extends Person {
  List<MoneySource> sources;
  List<Person> loaners;

  User({int id, String name, this.loaners, this.sources}) {
    this.id = id;
    this.name = name;
    if (sources == null) sources = [];
    if (loaners == null) loaners = [];
  }

  double get totalLent => loaners.fold<double>(0, (a, loaner) => a + loaner.totalOwned);
}