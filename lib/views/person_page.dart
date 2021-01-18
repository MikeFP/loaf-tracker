import 'package:cash_loaf/model/person.dart';
import 'package:cash_loaf/views/add_loan_page.dart';
import 'package:flutter/material.dart';

import '../utils/currency.dart';
import 'pay_loan_page.dart';

class PersonPage extends StatelessWidget {
  PersonPage({this.person});

  final Person person;

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: person.name,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(text: ' deve'),
                  ]),
                  style: Theme.of(context).textTheme.bodyText2),
              SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.baseline, children: [
                Text('R\$',
                    style: TextStyle(
                      letterSpacing: 1.2,
                    )),
                SizedBox(width: 4),
                Text(
                  person.totalOwned.toCurrency(useSymbol: false),
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 24,
                  ),
                ),
              ]),
              SizedBox(height: 24),
              OutlineButton(
                child: Text('REGISTRAR RETORNO'),
                textColor: Colors.black54,
                borderSide: BorderSide(color: Colors.black38),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PayLoanPage(person: person)));
                },
              ),
              SizedBox(height: 24),
              Text(
                'EMPRÉSTIMOS',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: Color(0xFF383838)),
              ),
              Divider(thickness: 2),
              ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                    person.loans.length,
                    (i) => ListTile(
                          contentPadding: EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                          title: Text(person.loans[i].description),
                          trailing: Text(person.loans[i].amount.toCurrency()),
                        ))
                  ..add(
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      title: Text('Total',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      trailing: Text(person.totalOwned.toCurrency(),
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    child: Text('EMPRESTAR'),
                    color: Colors.yellow[300],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddLoanPage(person: person)));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
