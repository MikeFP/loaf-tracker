import 'dart:async';

import 'package:cash_loaf/services/loan_service.dart';

import '../model/person.dart';
import 'package:flutter/widgets.dart';

class LoanProvider extends ChangeNotifier {
  final _loanStream = StreamController<List<Person>>.broadcast();
  Stream<List<Person>> get loanStream => _loanStream.stream;

  Future<void> getAllLoans() async {
    _loanStream.add(await LoanService.getAllLoans());
  }

  dispose() {
    super.dispose();
    _loanStream.close();
  }
}