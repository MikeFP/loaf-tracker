import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loaf_tracker/model/loan.dart';
import 'package:loaf_tracker/model/money_source.dart';
import 'package:loaf_tracker/model/user.dart';
import 'package:loaf_tracker/services/loan_service.dart';
import 'package:loaf_tracker/services/user_service.dart';

import '../model/person.dart';
import 'package:flutter/widgets.dart';

class LoanProvider extends ChangeNotifier {
  List<StreamSubscription<Object>> subs = [];

  LoanProvider() {
    _user = User();
    subs.addAll([
      loanerStream.listen((data) {
        user.loaners = data;
        _userStream.add(user);
      }),
      loanerCreatedStream.listen((data) {
        user.loaners.add(data);
        _userStream.add(user);
      }),
      loanerUpdatedStream.listen((data) {
        user.loaners[
            user.loaners.indexWhere((loaner) => loaner.id == data.id)] = data;
        _userStream.add(user);
      })
    ]);
  }

  final _loanerStream = StreamController<List<Person>>.broadcast();
  final _loanerCreatedStream = StreamController<Person>.broadcast();
  final _loanerUpdatedStream = StreamController<Person>.broadcast();
  final _userStream = StreamController<User>.broadcast();
  Stream<List<Person>> get loanerStream => _loanerStream.stream;
  Stream<Person> get loanerCreatedStream => _loanerCreatedStream.stream;
  Stream<Person> get loanerUpdatedStream => _loanerUpdatedStream.stream;
  Stream<User> get userStream => _userStream.stream;

  User _user;
  User get user => _user;

  Future<void> loadUser() async {
    if (_user.id == null) {
      _user = await UserService.createUser(env['MOCK_DATA'] == 'true' ? UserService.testUser : User());
    }
    _user = await UserService.getUser(user.id);
    _userStream.add(_user);
  }

  Future<void> getAllLoaners() async {
    var res = await LoanService.getAllLoaners();
    _loanerStream.add(res);
  }

  Future<void> saveLoaner(Person loaner) async {
    if (loaner.id == null) {
      _loanerCreatedStream.add(await LoanService.createLoaner(loaner));
    } else {
      await LoanService.saveLoans(loaner);
      _loanerUpdatedStream.add(loaner);
    }
  }

  Future<void> payLoans(
      Person loaner, List<Loan> paidLoans, List<Loan> updatedLoans,
      {List<MoneySource> updatedSources}) async {
    var res = await LoanService.payLoans(loaner, paidLoans,
        updatedLoans: updatedLoans, updatedSources: updatedSources);
    _loanerUpdatedStream.add(res);
  }

  Future<void> saveUser(User user) async {
    _user = await UserService.saveUser(user);
    _userStream.add(_user);
  }

  Future<void> deleteSource(MoneySource source) async {
    _user = await UserService.deleteSource(user, source);
    _userStream.add(_user);
  }

  dispose() {
    super.dispose();
    _loanerStream.close();
    _loanerCreatedStream.close();
    _loanerUpdatedStream.close();
    _userStream.close();
    for (var sub in subs) sub.cancel();
  }
}
