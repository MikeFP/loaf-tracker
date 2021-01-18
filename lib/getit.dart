import 'package:get_it/get_it.dart';

import 'providers/loan_provider.dart';
import 'services/database_service.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<LoanProvider>(LoanProvider());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}