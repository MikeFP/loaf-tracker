import 'package:after_layout/after_layout.dart';
import 'package:cash_loaf/model/person.dart';
import 'package:cash_loaf/providers/loan_provider.dart';
import 'package:flutter/material.dart';

import '../getit.dart';
import 'loan_page.dart';

class SelectPersonPage extends StatefulWidget {
  @override
  _SelectPersonPageState createState() => _SelectPersonPageState();
}

class _SelectPersonPageState extends State<SelectPersonPage>
    with AfterLayoutMixin {
  final provider = getIt<LoanProvider>();
  List<Person> contacts = [];

  @override
  void afterFirstLayout(BuildContext context) {
    provider.getAllLoans();
    provider.loanStream.listen((people) {
      setState(() {
        contacts = people;
      });
    });
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
          icon: Icon(Icons.close),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Qual o '),
                TextSpan(
                    text: 'nome',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' de quem está emprestando?'),
              ]),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Novo contato ou filtrar existente...',
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton.icon(
                  label: Text('ADICIONAR'),
                  icon: Icon(Icons.add),
                  color: Colors.yellow[300],
                  onPressed: () {},
                )
              ],
            ),
            SizedBox(height: 12),
            Text(
              'CONTATOS',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Color(0xFF383838)),
            ),
            Divider(thickness: 2),
            ListView(
              shrinkWrap: true,
              children: List<Widget>.generate(
                contacts.length,
                (i) => ListTile(
                  contentPadding: EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  title: Text(contacts[i].name),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoanPage(person: contacts[i])));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
