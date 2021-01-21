import 'package:flutter/material.dart';
import 'package:loaf_tracker/model/money_source.dart';
import 'package:loaf_tracker/providers/loan_provider.dart';
import 'package:loaf_tracker/utils/after_layout_mixin.dart';

import '../getit.dart';
import '../utils/currency.dart';
import 'add_source_page.dart';

class BalancePage extends StatefulWidget {
  BalancePage({this.loansTap});

  final Function() loansTap;

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> with AfterLayoutMixin {
  final provider = getIt<LoanProvider>();

  void _editSource(int index, MoneySource source) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSourcePage(source: source),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    provider.loadUser();
    provider.userStream.listen((data) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2B2B2B),
        toolbarHeight: 90,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SALDO',
              style: TextStyle(
                  letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 4),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, children: [
              Text('R\$',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  )),
              Text(
                provider.user.sources
                    .fold<double>(0, (v, s) => v + s.balance)
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
            Material(
              elevation: 4,
              color: Color(0xFF383838),
              child: InkWell(
                onTap: widget.loansTap,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    top: 14,
                    bottom: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMPRÉSTIMOS',
                        style: TextStyle(
                          letterSpacing: 1.6,
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text(
                                  'R\$',
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  provider.user.totalLent
                                      .toCurrency(useSymbol: false),
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ]),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 10),
                ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    provider.user.sources.length,
                    (i) => ListTile(
                      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      onTap: () {
                        _editSource(i, provider.user.sources[i]);
                      },
                      title: Text(
                        provider.user.sources[i].name,
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        provider.user.sources[i].balance.toCurrency(),
                        style: TextStyle(
                          letterSpacing: 1.2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSourcePage()));
        },
        tooltip: 'Adicionar fonte',
        child: Icon(Icons.add),
      ),
    );
  }
}
