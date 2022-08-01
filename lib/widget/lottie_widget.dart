
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {

  String assetPath;
  double width;
  double height;

  LottieWidget({required this.assetPath,required this.width,required this.height,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(assetPath,width: width,height: height);
  }
}
