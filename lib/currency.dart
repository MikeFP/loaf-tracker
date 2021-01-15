

import 'package:intl/intl.dart';

extension Currency on double {
  String toCurrency() {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(this);
  }
}