import 'dart:async';

extension DurationExt on int {
  Duration get toSecond {
    return Duration(seconds: this);
  }

  Duration get toDays {
    return Duration(days: this);
  }

  Duration get toMinutes {
    return Duration(minutes: this);
  }

  Duration get toHour {
    return Duration(hours: this);
  }

  Duration get toMilliSeconds {
    return Duration(milliseconds: this);
  }
}

extension FutureDurationExt on Duration {
  Future delayed<T>([FutureOr<T> computation()?]) {
    return Future.delayed(this, () => computation!());
  }
}
