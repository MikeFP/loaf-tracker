import 'dart:async';

import 'package:loaf_tracker/model/money_source.dart';
import 'package:loaf_tracker/model/user.dart';
import 'package:loaf_tracker/providers/loan_provider.dart';
import 'package:loaf_tracker/model/loan.dart';
import 'package:loaf_tracker/model/person.dart';
import 'package:loaf_tracker/shared/expandable_page_view.dart';
import 'package:loaf_tracker/utils/after_layout_mixin.dart';
import 'package:loaf_tracker/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../getit.dart';
import 'person_page.dart';

class PayLoanPage extends StatefulWidget {
  PayLoanPage({this.person});

  final Person person;

  @override
  _PayLoanPageState createState() => _PayLoanPageState();
}

class _PayLoanPageState extends State<PayLoanPage> with AfterLayoutMixin {
  final provider = getIt<LoanProvider>();
  final stepper = PageController();
  var amountText = MoneyMaskedTextController();
  int targetPage = 0;
  var checkState = Set();
  double totalSelected = 0;
  int overflowIndex = -1;

  double get amount => amountText.numberValue;
  double get overflowAmount => totalSelected - amount;
  double get cappedSelected => totalSelected.clamp(0, amount);
  List<Loan> get selectedLoans => widget.person.loans
      .asMap()
      .entries
      .where((entry) => checkState.contains(entry.key))
      .map((entry) => entry.value)
      .toList();
  Loan get overflowLoan =>
      overflowIndex != -1 ? widget.person.loans[overflowIndex] : null;

  StreamSubscription subs;
  User user;

  static const STEPS = 3;

  @override
  void initState() {
    super.initState();
    user = provider.user;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    subs = provider.userStream.listen((data) {
      setState(() {
        user = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }

  void _nextPage() {
    stepper.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
    setState(() {
      targetPage += stepper.page < STEPS - 1 ? 1 : 0;
    });
  }

  void _payLoan({MoneySource source}) {
    var paidLoans = selectedLoans.map((loan) => loan).toList()
      ..remove(overflowLoan);

    provider.payLoans(widget.person, paidLoans,
        [Loan(id: overflowLoan.id, amount: overflowAmount)],
        updatedSources: source != null
            ? [MoneySource(id: source.id, balance: source.balance + amount)]
            : null);
    provider.loanerUpdatedStream.first.then((loaner) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PersonPage(person: loaner),
          ),
          ModalRoute.withName('/'));
    });
  }

  void _setChecked(int index, bool value) {
    final selectedAmount = widget.person.loans[index].amount;
    if (!value) {
      if (overflowIndex != -1 &&
          (overflowIndex == index || selectedAmount > overflowAmount)) {
        overflowIndex = -1;
      }
      setState(() {
        totalSelected -= selectedAmount;
        checkState.remove(index);
      });
      return;
    }
    if (totalSelected + selectedAmount > amount) {
      overflowIndex = index;
    }
    setState(() {
      totalSelected += selectedAmount;
      checkState.add(index);
    });
  }

  bool _itemDisabled(int i) =>
      (totalSelected >= amount) && !checkState.contains(i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
          color: Colors.black87,
          onPressed: () {
            if (stepper.page == 0)
              Navigator.of(context).maybePop();
            else {
              stepper.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic);
              setState(() {
                targetPage -= stepper.page > 0 ? 1 : 0;
              });
            }
          },
          icon: (!layoutDone || targetPage == 0)
              ? Icon(Icons.close)
              : Icon(Icons.chevron_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: widget.person.name,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: (!layoutDone || targetPage == 0)
                                ? ' deve'
                                : ' está devolvendo'),
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
                        (!layoutDone || targetPage == 0)
                            ? widget.person.totalOwned
                                .toCurrency(useSymbol: false)
                            : amountText.text,
                        style: TextStyle(
                          letterSpacing: 1.2,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            ExpandablePageView(
              physics: NeverScrollableScrollPhysics(),
              controller: stepper,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'Quanto '),
                          TextSpan(
                            text: widget.person.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: ' está '),
                          TextSpan(
                            text: 'devolvendo',
                            style: TextStyle(color: Colors.yellow[900]),
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
                          FlatButton.icon(
                            onPressed: _nextPage,
                            label: Icon(Icons.arrow_right),
                            icon: Text('CONTINUAR'),
                            padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Selecione os itens que serão quitados'),
                      SizedBox(height: 10),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 100, maxHeight: 350),
                        child: ListView(
                          shrinkWrap: true,
                          children: List<Widget>.generate(
                              widget.person.loans.length,
                              (i) => ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(
                                        widget.person.loans[i].description,
                                        style: _itemDisabled(i)
                                            ? TextStyle(color: Colors.black54)
                                            : TextStyle()),
                                    onTap: _itemDisabled(i)
                                        ? null
                                        : () {
                                            _setChecked(
                                                i, !checkState.contains(i));
                                          },
                                    leading: Checkbox(
                                      value: checkState.contains(i),
                                      onChanged: _itemDisabled(i)
                                          ? null
                                          : (val) {
                                              _setChecked(i, val);
                                            },
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.person.loans[i].amount
                                              .toCurrency(),
                                          style: TextStyle(
                                              fontStyle: checkState.contains(i)
                                                  ? FontStyle.italic
                                                  : FontStyle.normal,
                                              decoration: checkState.contains(i)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              color: _itemDisabled(i)
                                                  ? Colors.black54
                                                  : null),
                                        ),
                                        overflowIndex == i
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                ),
                                                child: Text(overflowAmount
                                                    .toCurrency()))
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ))
                            ..add(
                              Column(
                                children: [
                                  Divider(thickness: 2),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text('Total a quitar',
                                        style:
                                            TextStyle(color: Colors.black54)),
                                    leading: Opacity(
                                      opacity: 0,
                                      child: Checkbox(
                                          tristate: true,
                                          onChanged: null,
                                          value: false),
                                    ),
                                    trailing: Text(cappedSelected.toCurrency(),
                                        style:
                                            TextStyle(color: Colors.black54)),
                                  ),
                                ],
                              ),
                            ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed:
                                totalSelected < amount ? null : _nextPage,
                            child: Text('CONTINUAR'),
                            color: Colors.yellow[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Escolha uma '),
                            TextSpan(
                                text: 'fonte',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            TextSpan(
                              text: (' para acrescentar o valor recebido:'),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _payLoan,
                            child: Text('PULAR'),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: 100, maxHeight: 350),
                        child: ListView(
                          shrinkWrap: true,
                          children: List<Widget>.generate(
                            user.sources.length,
                            (i) => ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(user.sources[i].name),
                              trailing: Text(
                                user.sources[i].balance.toCurrency(),
                                style: TextStyle(
                                  letterSpacing: 1.2,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                _payLoan(source: user.sources[i]);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
