import 'package:loaf_tracker/model/person.dart';
import 'package:loaf_tracker/shared/expandable_page_view.dart';
import 'package:loaf_tracker/utils/after_layout_mixin.dart';
import 'package:loaf_tracker/utils/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'person_page.dart';

class PayLoanPage extends StatefulWidget {
  PayLoanPage({this.person});

  final Person person;

  @override
  _PayLoanPageState createState() => _PayLoanPageState();
}

class _PayLoanPageState extends State<PayLoanPage> with AfterLayoutMixin {
  final stepper = PageController();
  var amountText = MoneyMaskedTextController();
  int targetPage = 0;
  var checkState = Set();
  double totalSelected = 0;
  int overflowIndex = -1;

  double get amount => amountText.numberValue;
  double get overflowAmount => totalSelected - amount;
  double get cappedSelected => totalSelected.clamp(0, amount);

  @override
  void afterFirstLayout(BuildContext context) {}

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
                            onPressed: () {
                              stepper.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOutCubic);
                              setState(() {
                                targetPage += stepper.page < 1 ? 1 : 0;
                              });
                            },
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
                                      child: Checkbox(tristate: true),
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
                            onPressed: totalSelected < amount
                                ? null
                                : () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonPage(person: widget.person),
                                        ),
                                        ModalRoute.withName('/'));
                                  },
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
          ],
        ),
      ),
    );
  }
}
