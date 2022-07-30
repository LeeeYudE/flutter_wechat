import 'package:flutter/cupertino.dart';

typedef OnItemVisibleListener = void Function(int firstIndex, int lastIndex, double leadingScrollOffset, double trailingScrollOffset);

class _SaltedValueKey extends ValueKey{
  const _SaltedValueKey(Key key): super(key);
}

class MyChildrenDelegate extends SliverChildBuilderDelegate {

  OnItemVisibleListener listener;

  MyChildrenDelegate(
      Widget Function(BuildContext, int) builder,
        this.listener,{
        int? childCount,
        bool addAutomaticKeepAlive = true,
        bool addRepaintBoundaries = true,
      }) : super(builder,
      childCount: childCount,
      addAutomaticKeepAlives: addAutomaticKeepAlive,
      addRepaintBoundaries: addRepaintBoundaries);
  // Return a Widget for the given Exception
  Widget _createErrorWidget(dynamic exception, StackTrace stackTrace) {
    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: exception,
      stack: stackTrace,
      library: 'widgets library',
      context: ErrorDescription('building'),
    );
    FlutterError.reportError(details);
    return ErrorWidget.builder(details);
  }
  @override
  Widget? build(BuildContext context, int index) {
    if (index < 0 || (childCount != null && index >= childCount!)) {
      return null;
    }
    Widget? child;
    try {
      child = builder(context, index);
    } catch (exception, stackTrace) {
      child = _createErrorWidget(exception, stackTrace);
    }
    if (child == null) {
      return null;
    }
    final Key? key = child.key != null ? _SaltedValueKey(child.key!) : null;
    if (addRepaintBoundaries) {
      child = RepaintBoundary(child: child);
    }
    if (addSemanticIndexes) {
      final int? semanticIndex = semanticIndexCallback(child, index);
      if (semanticIndex != null) {
        child = IndexedSemantics(index: semanticIndex + semanticIndexOffset, child: child);
      }
    }
    if (addAutomaticKeepAlives) {
      child = AutomaticKeepAlive(child: child);
    }
    return KeyedSubtree(child: child, key: key);
  }

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    super.didFinishLayout(firstIndex, lastIndex);
    listener(firstIndex,lastIndex,0,0);
  }
  ///监听 在可见的列表中 显示的第一个位置和最后一个位置
  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex, double leadingScrollOffset, double trailingScrollOffset) {
    return super.estimateMaxScrollOffset(firstIndex, lastIndex, leadingScrollOffset, trailingScrollOffset);
  }
}