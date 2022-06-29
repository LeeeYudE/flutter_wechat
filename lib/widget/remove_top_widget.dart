import 'package:flutter/material.dart';

class RemoveTopPaddingWidget extends StatelessWidget {

  Widget child;

  RemoveTopPaddingWidget({required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child:child ,
    );
  }
}
