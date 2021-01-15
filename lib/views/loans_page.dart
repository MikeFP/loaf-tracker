import 'package:after_layout/after_layout.dart';
import 'package:cash_loaf/model/person.dart';
import 'package:cash_loaf/providers/loan_provider.dart';
import 'package:cash_loaf/currency.dart';
import 'package:flutter/material.dart';

import '../getit.dart';
import 'person_page.dart';

class LoansPage extends StatefulWidget {
  @override
  _LoansPageState createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> with AfterLayoutMixin {
  final provider = getIt<LoanProvider>();
  List<Person> loans = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    provider.getAllLoans();
    provider.loanStream.listen((loans) {
      this.loans = loans;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2B2B),
        toolbarHeight: 90,
        leading: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                icon: Icon(Icons.chevron_left),
              ),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'EMPRÉSTIMOS',
              style: TextStyle(
                  letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 4),
            Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('R\$',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      )),
                  SizedBox(width: 4),
                  Text(
                    loans
                        .fold<double>(0, (t, loan) => t + loan.totalOwned)
                        .toCurrency(useSymbol: false),
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: loans != null ? loans.length : 0,
              itemBuilder: (context, i) => ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonPage(person: loans[i])));
                },
                contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                title: Text(loans[i].name),
                trailing: Text('${loans[i].totalOwned.toCurrency()}',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 16,
                    )),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Novo empréstimo',
        child: Icon(Icons.add),
      ),
    );
  }
}
