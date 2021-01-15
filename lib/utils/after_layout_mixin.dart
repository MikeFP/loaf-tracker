import 'package:flutter/widgets.dart';

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  bool _layoutDone = false;
  bool get layoutDone => _layoutDone;

  @override
  void initState() {
    super.initState();
    _layoutDone = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _layoutDone = true;
      afterFirstLayout(context);
    });
  }

  void afterFirstLayout(BuildContext context);
}
