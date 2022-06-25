import 'dart:async';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';

import '../utils/event_util.dart';

///流统一管理
mixin SubscriptionMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _streamList = [];
  final List<Timer> _timerList = [];

  // /// event 监听
  StreamSubscription eventListen<T>(ValueChanged<T> listen) {
    final stream = EventBusUtil.Event_Bus.on<T>().listen((value) {
      //页面销毁就不返回了
      if (mounted) {
        listen(value);
      }
    });
    _addStreamSubscription(stream);
    return stream;
  }

  void _addStreamSubscription(StreamSubscription sub) {
    _streamList.add(sub);
  }

  void _addTimerSubscription(Timer timer) {
    _timerList.add(timer);
  }

  ///延迟处理
  ///@params milliSeconds 延迟多少毫秒执行
  StreamSubscription delay<T>(int milliSeconds, ValueChanged<T> listen) {
    final stream = Stream.fromFuture(Future.delayed(milliSeconds.toMilliSeconds)).listen((event) {
      if (mounted) {
        listen(event);
      }
    });
    _addStreamSubscription(stream);
    return stream;
  }

  ///定时
  ///@params milliSeconds 每多少毫秒执行回调一次
  Timer periodic(int milliSeconds, void Function(Timer timer) callback) {
    final _timer = Timer.periodic(milliSeconds.toMilliSeconds, (t) {
      if (mounted) {
        callback(t);
      }
    });
    _addTimerSubscription(_timer);
    return _timer;
  }

  @override
  void dispose() {
    for (var element in _streamList) {
      element.cancel();
    }
    for (var element in _timerList) {
      if (element.isActive) {
        element.cancel();
      }
    }
    super.dispose();
  }
}

mixin SubscriptionMixinGet on GetxController {
  final List<StreamSubscription> _streamList = [];
  final List<Timer> _timerList = [];

  /// event 监听
  StreamSubscription eventListen<T>(ValueChanged<T> listen) {
    final stream = EventBusUtil.Event_Bus.on<T>().listen((value) {
      //页面销毁就不返回了
      if (!isClosed) {
        listen(value);
      }
    });
    _addStreamSubscription(stream);
    return stream;
  }

  void _addStreamSubscription(StreamSubscription sub) {
    debugPrint('SubscriptionMixinGet, $this,StreamSubscription->$sub, add');
    _streamList.add(sub);
  }

  void _addTimerSubscription(Timer timer) {
    debugPrint('SubscriptionMixinGet, $this,StreamSubscription Timer->$timer, add');
    _timerList.add(timer);
  }

  ///延迟处理
  ///@params milliSeconds 延迟多少毫秒执行
  StreamSubscription delay<T>(int milliSeconds, ValueChanged<T> listen) {
    final stream = Stream.fromFuture(Future.delayed(milliSeconds.toMilliSeconds)).listen((event) {
      if (!isClosed) {
        listen(event);
      }
    });
    _addStreamSubscription(stream);
    return stream;
  }

  ///定时
  ///@params milliSeconds 每多少毫秒执行回调一次
  Timer periodic(int milliSeconds, void Function(Timer timer) callback) {
    final _timer = Timer.periodic(milliSeconds.toMilliSeconds, (t) {
      if (!isClosed) {
        callback(t);
      }
    });
    _addTimerSubscription(_timer);
    return _timer;
  }

  @override
  void dispose() {
    for (var element in _streamList) {
      element.cancel();
    }
    for (var element in _timerList) {
      if (element.isActive) {
        element.cancel();
      }
    }
    super.dispose();
  }
}
