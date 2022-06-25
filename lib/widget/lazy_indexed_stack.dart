
import 'package:flutter/widgets.dart';

class LazyIndexedStack extends StatefulWidget {
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int index;
  final int? preLoadIndex;

  //reuse the created view
  final bool reuse;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  final int notReuseIndex;

  const LazyIndexedStack(
      {Key? key,
      this.alignment = AlignmentDirectional.topStart,
      this.textDirection,
      this.sizing = StackFit.loose,
      this.index=0,
      this.reuse = true,
      required this.itemBuilder,
      this.itemCount = 0,
      this.preLoadIndex,
      this.notReuseIndex = -1})
      : super(key: key);

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late List<Widget> _children;
  late List<bool> _loaded;

  @override
  void initState() {
    _initTabs();
    super.initState();
  }

  void _initTabs() {
    _loaded = [];
    _children = [];
    for (int i = 0; i < widget.itemCount; ++i) {
      if (i == widget.index || i == widget.preLoadIndex) {
        _children.add(widget.itemBuilder(context, i));
        _loaded.add(true);
      } else {
        _children.add(Container());
        _loaded.add(false);
      }
    }
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    //tabs数发生变化
    if (oldWidget.itemCount != widget.itemCount) {
      _initTabs();
    }

    for (int i = 0; i < widget.itemCount; ++i) {
      if (i == widget.index) {
        if (!_loaded[i]) {
          _children[i] = widget.itemBuilder(context, i);
          _loaded[i] = true;
        } else {
          if (widget.reuse && i != widget.notReuseIndex) {
            return;
          }
          _children[i] = widget.itemBuilder(context, i);
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: _children,
    );
  }
}
