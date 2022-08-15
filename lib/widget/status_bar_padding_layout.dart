import 'package:flutter/material.dart';

class StatusBarPaddingLayout extends StatelessWidget {

  Widget child;

  StatusBarPaddingLayout({required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: child,
    );
  }
}
