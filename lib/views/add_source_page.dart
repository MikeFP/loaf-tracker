import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loaf_tracker/model/money_source.dart';
import 'package:loaf_tracker/providers/loan_provider.dart';

import '../getit.dart';

class AddSourcePage extends StatefulWidget {
  AddSourcePage({this.source});

  final MoneySource source;

  @override
  _AddSourcePageState createState() => _AddSourcePageState();
}

class _AddSourcePageState extends State<AddSourcePage> {
  var provider = getIt<LoanProvider>();
  var nameText = TextEditingController();
  var balanceText = MoneyMaskedTextController();
  var _focus = new FocusNode();

  bool get editMode => widget.source != null;

  @override
  void initState() {
    super.initState();
    nameText.text = editMode ? widget.source.name : '';
    balanceText = MoneyMaskedTextController(
        initialValue: editMode ? widget.source.balance : 0);
    if (editMode) {
      _focus.addListener(() {
        if (_focus.hasFocus &&
            balanceText.numberValue == widget.source.balance) {
          balanceText.text = '0,00';
        }
      });
    }
  }

  void _saveSource() {
    var index = provider.user.sources.indexOf(widget.source);
    var oldSource = editMode ? provider.user.sources[index] : null;
    var source =
        MoneySource(name: nameText.text, balance: balanceText.numberValue);
    if (editMode) {
      source.id = widget.source.id;
      provider.user.sources[index] = source;
    } else {
      provider.user.sources.add(source);
    }
    provider.saveUser(provider.user).then((data) {
      Navigator.pop(context, source);
    }, onError: (err) {
      if (editMode) {
        provider.user.sources[index] = oldSource;
      } else {
        provider.user.sources.removeLast();
      }
    });
  }

  void _openDeleteDialog() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remover fonte'),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Deseja realmente excluir a fonte monetária '),
              TextSpan(
                  text: widget.source.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              'SIM',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              provider.deleteSource(widget.source).then((_) {
                Navigator.pop(context, true);
              });
            },
          ),
          RaisedButton(
            child: Text('NÃO'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          )
        ],
      ),
    ).then((res) {
      if(res) {
        Navigator.pop(context, null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Scaffold(
          backgroundColor: Color(0x0),
          appBar: AppBar(
            backgroundColor: Color(0x0),
            elevation: 0,
            leading: IconButton(
              color: Colors.black87,
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              icon: Icon(Icons.close),
            ),
            actions: [
              editMode
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: _openDeleteDialog,
                        color: Colors.red[300],
                        icon: Icon(Icons.delete),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    !editMode ? 'Nova fonte monetária' : widget.source.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 32),
                  Text('Como deseja chamar essa fonte?'),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Banco, colchão, carteira etc.',
                    ),
                    controller: nameText,
                  ),
                  SizedBox(height: 24),
                  Text(editMode
                      ? 'Informe o novo saldo'
                      : 'Informe o saldo inicial'),
                  TextField(
                    focusNode: _focus,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefix: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('R\$'),
                      ),
                    ),
                    controller: balanceText,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      editMode
                          ? RaisedButton(
                              onPressed: _saveSource,
                              child: Text('SALVAR'),
                              color: Colors.yellow[300],
                            )
                          : RaisedButton.icon(
                              padding: EdgeInsets.fromLTRB(16, 0, 10, 0),
                              icon: Text('ADICIONAR'),
                              label: Icon(Icons.add),
                              color: Colors.yellow[300],
                              onPressed: _saveSource,
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
