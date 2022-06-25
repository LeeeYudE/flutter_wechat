import 'package:flutter/widgets.dart';

class TransparentRoute<T> extends PageRoute<T> {
  TransparentRoute({
    required this.builder,
    RouteSettings? settings,
  })  : super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: FadeTransition(
        opacity: animation,
        child: result,
      ),
    );
  }
}
