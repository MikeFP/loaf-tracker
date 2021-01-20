import 'dart:async';

import 'package:loaf_tracker/model/loan.dart';
import 'package:loaf_tracker/services/loan_service.dart';

import '../model/person.dart';
import 'package:flutter/widgets.dart';

class LoanProvider extends ChangeNotifier {
  final _loanerStream = StreamController<List<Person>>.broadcast();
  final _loanerCreatedStream = StreamController<Person>.broadcast();
  final _loanerUpdatedStream = StreamController<Person>.broadcast();
  Stream<List<Person>> get loanerStream => _loanerStream.stream;
  Stream<Person> get loanerCreatedStream => _loanerCreatedStream.stream;
  Stream<Person> get loanerUpdatedStream => _loanerUpdatedStream.stream;

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

  Future<void> payLoans(Person loaner, List<Loan> paidLoans, List<Loan> updatedLoans) async {
    _loanerUpdatedStream.add(await LoanService.payLoans(loaner, paidLoans, updatedLoans));
  }

  dispose() {
    super.dispose();
    _loanerStream.close();
    _loanerCreatedStream.close();
    _loanerUpdatedStream.close();
  }
}