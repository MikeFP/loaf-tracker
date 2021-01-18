

import 'package:intl/intl.dart';

extension Currency on double {
  String toCurrency({bool useSymbol = true}) {
    var res = NumberFormat.currency(locale: 'pt_BR', symbol: useSymbol ? 'R\$' : '').format(this);
    if (!useSymbol) res = res.substring(1);
    return res;
  }
}