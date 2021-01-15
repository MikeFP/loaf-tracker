import 'package:get_it/get_it.dart';

import 'providers/loan_provider.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<LoanProvider>(LoanProvider());
}