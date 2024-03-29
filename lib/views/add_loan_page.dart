import 'package:loaf_tracker/model/loan.dart';
import 'package:loaf_tracker/model/person.dart';
import 'package:loaf_tracker/providers/loan_provider.dart';
import 'package:loaf_tracker/utils/after_layout_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../getit.dart';
import '../utils/currency.dart';
import 'person_page.dart';

class AddLoanPage extends StatefulWidget {
  AddLoanPage({this.person});

  final Person person;

  @override
  _AddLoanPageState createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> with AfterLayoutMixin {
  final provider = getIt<LoanProvider>();
  var amountText = MoneyMaskedTextController();
  var descriptionText = TextEditingController();
  var stepper = PageController();
  var targetPage = 0;
  final _focusNode = FocusNode();

  int get page => layoutDone ? stepper.page.round() : 0;

  void _saveLoan() {
    var loaner = Person(
      id: widget.person.id,
      name: widget.person.name,
      loans: widget.person.loans
        ..add(Loan(
          amount: amountText.numberValue,
          description: descriptionText.text,
          date: DateTime.now(),
        )),
    );
    provider.saveLoaner(loaner);
    var callback = (Person data) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PersonPage(person: data)),
          ModalRoute.withName('/'));
    };
    if (widget.person.id == null) {
      provider.loanerCreatedStream.first.then(callback);
    } else {
      provider.loanerUpdatedStream.first.then(callback);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  void initState() {
    super.initState();
  }

  void _nextStep() {
    stepper.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
    setState(() {
      targetPage += stepper.page < 1 ? 1 : 0;
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _previousStep() {
    if (stepper.page == 0)
      Navigator.of(context).maybePop();
    else {
      stepper.previousPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
      setState(() {
        targetPage -= stepper.page > 0 ? 1 : 0;
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        leading: IconButton(
          color: Colors.black87,
          onPressed: _previousStep,
          icon: (!layoutDone || targetPage == 0)
              ? Icon(Icons.close)
              : Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
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
                              : ' está emprestando'),
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
          Expanded(
            child: PageView(
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
                        focusNode: targetPage == 0 ? _focusNode : null,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefix: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Text('R\$'),
                          ),
                        ),
                        controller: amountText,
                        onChanged: (val) {
                          setState(() {});
                        },
                        onSubmitted: (val) {
                          _nextStep();
                        },
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton.icon(
                            onPressed:
                                amountText.numberValue != 0 ? _nextStep : null,
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
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Digite algo para identificar este empréstimo'),
                      TextField(
                        autofocus: true,
                        focusNode: targetPage == 1 ? _focusNode : null,
                        decoration: InputDecoration(
                          hintText: 'ex.: Uber, comida, etc.',
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        controller: descriptionText,
                        style: TextStyle(fontSize: 20),
                        onSubmitted: (val) => _saveLoan(),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: _saveLoan,
                            child: Text('CONCLUIR'),
                            color: Colors.yellow[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
