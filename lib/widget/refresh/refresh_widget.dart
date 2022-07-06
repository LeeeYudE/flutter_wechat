import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/widget/refresh/refresh_footer.dart';
import 'package:wechat/widget/refresh/refresh_header.dart';

typedef RefreshListener = Future<bool> Function(RefreshController? controller);
typedef FooterBuild = Widget Function(LoadStatus? status);

class RefreshWidget extends StatefulWidget {
  final bool enablePullUp;
  final bool enablePullDown;
  final RefreshController? controller;
  final Widget? child;
  final RefreshListener? onRefresh;
  final RefreshListener? onLoading;
  final FooterBuild? footerBuild;
  final bool initialRefresh;

  const RefreshWidget({
    this.child,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.controller,
    this.onLoading,
    this.onRefresh,
    this.footerBuild,
    this.initialRefresh = false
  });

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  RefreshController? _refreshController;

  @override
  void initState() {
    _refreshController = widget.controller;
    _refreshController ??= RefreshController(initialRefresh: false);
    if(widget.initialRefresh){
      WidgetsBinding.instance?.addPostFrameCallback((callback) {
        _onRefresh();
      });
    }

    super.initState();
  }

  _onRefresh() async {
    if (widget.onRefresh != null) {
      final bool more = await widget.onRefresh!(_refreshController);
      _refreshController!.refreshCompleted();
      debugPrint('_onRefresh $more');
      if (!more) {
        _refreshController!.loadNoData();
      }
    }
  }

  _onLoading() async {
    if (widget.onRefresh != null) {
      final bool more = await widget.onLoading!(_refreshController);
      debugPrint('_onLoading $more');
      if (more) {
        _refreshController!.loadComplete();
      } else {
        _refreshController!.loadNoData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      onRefresh: () {
        _onRefresh();
      },
      onLoading: () {
        _onLoading();
      },
      controller: _refreshController!,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          return widget.footerBuild != null? widget.footerBuild!(mode) : RefreshFooter(
            status: mode,
          );
        },
      ),
      header: CustomHeader(
        builder: (BuildContext context, RefreshStatus? mode) {
          return RefreshHeader(
            status: mode,
          );
        },
      ),
      child: widget.child ?? Container(),
    );
  }
}
