import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:loaf_tracker/model/person.dart';
import 'package:loaf_tracker/providers/loan_provider.dart';
import 'package:loaf_tracker/utils/currency.dart';
import 'package:loaf_tracker/views/select_person_page.dart';
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
  List<StreamSubscription<Object>> subs = [];

  @override
  void initState() {
    super.initState();
    subs.add(provider.loanerStream.listen((loans) {
      this.loans = loans;
      if (mounted) {
        setState(() {});
      }
    }));
    subs.add(provider.loanerCreatedStream.listen((loaner) {
      this.loans.add(loaner);
      if (mounted) {
        setState(() {});
      }
    }));
    subs.add(provider.loanerUpdatedStream.listen((loaner) {
      var i = this.loans.indexWhere((item) => item.id == loaner.id);
      if (i == -1) {
        this.loans[i] = loaner;
      }
      if (mounted) {
        setState(() {});
      }
    }));
  }

  void _getLoaners() {
    provider.getAllLoaners();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _getLoaners();
  }

  @override
  void dispose() {
    super.dispose();
    subs.forEach((sub) => sub.cancel());
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: loans != null ? loans.length : 0,
              itemBuilder: (context, i) => ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/loaner"),
                        builder: (context) => PersonPage(person: loans[i])),
                  ).then((_) {
                    _getLoaners();
                  });
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectPersonPage()),
          ).then((_) {
            _getLoaners();
          });
        },
        tooltip: 'Novo empréstimo',
        child: Icon(Icons.add),
      ),
    );
  }
}
