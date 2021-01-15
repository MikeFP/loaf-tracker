import 'package:cash_loaf/model/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../currency.dart';

class LoanPage extends StatefulWidget {
  LoanPage({this.person});

  final Person person;

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  TextEditingController amountText = MoneyMaskedTextController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
          color: Colors.black87,
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: Icon(Icons.chevron_left),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: widget.person.name,
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: ' deve'),
                ]),
                style: Theme.of(context).textTheme.bodyText2),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text('R\$',
                    style: TextStyle(
                      letterSpacing: 1.2,
                    )),
                SizedBox(width: 4),
                Text(
                  widget.person.totalOwned.toCurrency(useSymbol: false),
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Quanto você está '),
                TextSpan(
                  text: 'emprestando',
                  style: TextStyle(color: Colors.yellow[900]),
                ),
                TextSpan(text: ' para '),
                TextSpan(
                  text: widget.person.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: '?'),
              ]),
            ),
            TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefix: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('R\$'),
                ),
              ),
              controller: amountText,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: Icon(Icons.arrow_right),
                  icon: Text('CONTINUAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
