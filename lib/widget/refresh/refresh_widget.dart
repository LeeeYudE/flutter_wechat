import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pull_to_refresh;
import 'package:wechat/widget/refresh/refresh_footer.dart';
import 'package:wechat/widget/refresh/refresh_header.dart';

typedef RefreshListener = Future<bool> Function(pull_to_refresh.RefreshController? controller);
typedef FooterBuild = Widget Function(pull_to_refresh.LoadStatus? status);

class RefreshWidget extends StatefulWidget {
  final bool enablePullUp;
  final bool enablePullDown;
  final pull_to_refresh.RefreshController? controller;
  final Widget? child;
  final RefreshListener? onRefresh;
  final RefreshListener? onLoading;
  final FooterBuild? footerBuild;
  final bool initialRefresh;
  final pull_to_refresh.RefreshIndicator? loadHeader;
  final pull_to_refresh.LoadIndicator? loadFooter;

  const RefreshWidget({
    this.child,
    this.enablePullDown = true,
    this.enablePullUp = true,
    this.controller,
    this.onLoading,
    this.onRefresh,
    this.footerBuild,
    this.initialRefresh = false,
    this.loadHeader,
    this.loadFooter
  });

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  pull_to_refresh.RefreshController? _refreshController;

  @override
  void initState() {
    _refreshController = widget.controller;
    _refreshController ??= pull_to_refresh.RefreshController(initialRefresh: false);
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
    return pull_to_refresh.SmartRefresher(
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      onRefresh: () {
        _onRefresh();
      },
      onLoading: () {
        _onLoading();
      },
      controller: _refreshController!,
      footer:widget.loadFooter??pull_to_refresh.CustomFooter(
        builder: (BuildContext context, pull_to_refresh.LoadStatus? mode) {
          return widget.footerBuild != null? widget.footerBuild!(mode) : RefreshFooter(
            status: mode,
          );
        },
      ),
      header: widget.loadHeader??pull_to_refresh.CustomHeader(
        builder: (BuildContext context, pull_to_refresh.RefreshStatus? mode) {
          return RefreshHeader(
            status: mode,
          );
        },
      ),
      child: widget.child ?? Container(),
    );
  }
}
