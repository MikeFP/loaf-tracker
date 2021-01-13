import 'package:flutter/material.dart';

class BalancePage extends StatelessWidget {

  BalancePage({this.loansTap});

  final Function() loansTap;

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
                '1.078,55',
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
          Material(
            color: Color(0xFF383838),
            child: InkWell(
              onTap: this.loansTap,
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
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              Text('R\$',
                                  style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  )),
                              Text(
                                '19.060,00',
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                title: Text('Nubank',
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
                title: Text('Inter',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                    )),
                trailing: Text('R\$ 50,00',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 16,
                    )),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                title: Text('PicPay',
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 16,
                    )),
                trailing: Text('R\$ 440,00',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 16,
                    )),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Adicionar fonte',
        child: Icon(Icons.add),
      ),
    );
  }
}
