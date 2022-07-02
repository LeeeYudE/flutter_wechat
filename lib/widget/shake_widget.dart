import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {

  Widget child;
  bool autoShake;

  ShakeWidget({required this.child ,this.autoShake = false, Key? key}) : super(key: key);

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();

}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin{

  AnimationController? _animationController;
  Animation<Offset>? animation;
  int _count = 0;

  void shakeMe() {
    WidgetsBinding.instance?.addPostFrameCallback((callback) {
      if (_animationController != null &&!_animationController!.isAnimating) {
        _count = 0;
        _animationController?.forward();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController?.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if(_count < 3){
          _count++;
          _animationController?.forward();
        }
      }
    });
    animation = Tween(begin: Offset.zero, end: const Offset(0.1, 0)).animate(_animationController!);
    if(widget.autoShake) {
      _animationController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: animation!, child: widget.child,);
  }

}
