import 'package:flutter/material.dart';

import 'views/balance_page.dart';
import 'views/loans_page.dart';
import 'getit.dart';

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.yellow[300],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.black87,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            height: 1.2,
          ),
          subtitle1: TextStyle(
            fontSize: 16,
            letterSpacing: 1,
            height: 1.2,
          ),
          subtitle2: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 1.5,
            height: 1.2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.black45),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow[800])),
        ),
      ),
      home: MyHomePage(title: 'Cash Loaf'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pager;

  @override
  void initState() {
    super.initState();
    pager = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (pager.page == 0) return true;

        pager.previousPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
        return false;
      },
      child: PageView(controller: pager, children: [
        BalancePage(
          loansTap: () {
            setState(() {
              pager.animateToPage(1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic);
            });
          },
        ),
        LoansPage(),
      ]),
    );
  }
}
