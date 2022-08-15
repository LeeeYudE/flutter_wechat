import 'package:flutter/material.dart';

class KeyboardObserverLayout extends StatefulWidget {

  ValueChanged<double> onKeyboardChange;
  Widget child;

  KeyboardObserverLayout({required this.child , required this.onKeyboardChange,Key? key}) : super(key: key);

  @override
  State<KeyboardObserverLayout> createState() => _KeyboardObserverLayoutState();
}

class _KeyboardObserverLayoutState extends State<KeyboardObserverLayout> with WidgetsBindingObserver {

  @override
  initState(){
    super.initState();
    _init();
  }

  void _init() async {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted) {
        final bottom = MediaQuery
            .of(context)
            .viewInsets
            .bottom;
        widget.onKeyboardChange.call(bottom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
