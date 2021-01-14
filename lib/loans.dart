import 'package:flutter/material.dart';

class LoansPage extends StatelessWidget {
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
                  Text(
                    '19.060,00',
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
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            title: Text('Fulano',
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                )),
            trailing: Text('R\$ 100,00',
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 16,
                )),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            title: Text('Beltrano',
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                )),
            trailing: Text('R\$ 150,00',
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 16,
                )),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            title: Text('Cicrano',
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 16,
                )),
            trailing: Text('R\$ 4.100,00',
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 16,
                )),
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
