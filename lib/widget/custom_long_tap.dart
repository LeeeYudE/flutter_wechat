import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GestureDetectorCustomLongTapDuration extends StatelessWidget {
  const GestureDetectorCustomLongTapDuration(
      {Key? key,
        this.duration = const Duration(milliseconds: 200),
        this.onLongPress,
        this.onTap,
        this.onCancel,
        this.onTapDown,
        this.onTapUp,
        this.onSecondaryTap,
        this.onSecondaryCancel,
        this.onSecondaryTapDown,
        this.onSecondaryTapUp,
        this.onTertiaryTapCancel,
        this.onTertiaryTapUp,
        this.onTertiaryTapDown,
        this.onLongPressEnd,
        this.onLongPressMoveUpdate,
        this.onLongPressStart,
        this.onLongPressUp,
        this.onSecondaryLongPressEnd,
        this.onSecondaryLongPressMoveUpdate,
        this.onSecondaryLongPressStart,
        this.onSecondaryLongPressUp,
        this.onSecondatyLongPress,
        this.onTertiaryLongPress,
        this.onTertiaryLongPressEnd,
        this.onTertiaryLongPressMoveUpdate,
        this.onTertiaryLongPressStart,
        this.onTertiaryLongPressUp,
        this.behavior,
        this.child})
      : super(key: key);
  final Duration duration;
  final Function? onTap;
  final Function? onCancel;
  final Function? onTapDown;
  final Function? onTapUp;
  final Function? onSecondaryTap;
  final Function? onSecondaryCancel;
  final Function? onSecondaryTapDown;
  final Function? onSecondaryTapUp;
  final Function? onTertiaryTapCancel;
  final Function? onTertiaryTapUp;
  final Function? onTertiaryTapDown;
  final Function? onLongPress;
  final Function? onLongPressEnd;
  final Function? onLongPressMoveUpdate;
  final Function? onLongPressStart;
  final Function? onLongPressUp;
  final Function? onSecondatyLongPress;
  final Function? onSecondaryLongPressEnd;
  final Function? onSecondaryLongPressMoveUpdate;
  final Function? onSecondaryLongPressStart;
  final Function? onSecondaryLongPressUp;
  final Function? onTertiaryLongPress;
  final Function? onTertiaryLongPressEnd;
  final Function? onTertiaryLongPressStart;
  final Function? onTertiaryLongPressMoveUpdate;
  final Function? onTertiaryLongPressUp;
  final HitTestBehavior? behavior;
  final Widget? child; // Child widget of the CustomLongTap
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      child: child,
      behavior: behavior,
      gestures: {
        TapGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (instance) {
            instance.onTap = onTap as void Function()?;
            instance.onTapCancel = onCancel as void Function()?;
            instance.onTapDown = onTapDown as void Function(TapDownDetails)?;
            instance.onTapUp = onTapUp as void Function(TapUpDetails)?;
            instance.onSecondaryTap = onSecondaryTap as void Function()?;
            instance.onSecondaryTapCancel = onSecondaryCancel as void Function()?;
            instance.onSecondaryTapDown = onSecondaryTapDown as void Function(TapDownDetails)?;
            instance.onSecondaryTapUp = onSecondaryTapUp as void Function(TapUpDetails)?;
            instance.onTertiaryTapCancel = onTertiaryTapCancel as void Function()?;
            instance.onTertiaryTapDown = onTertiaryTapDown as void Function(TapDownDetails)?;
            instance.onTertiaryTapUp = onTertiaryTapUp as void Function(TapUpDetails)?;
          },
        ),
        LongPressGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(duration: duration),
              (instance) {
            instance.onLongPress = onLongPress as void Function()?;
            instance.onLongPressEnd = onLongPressEnd as void Function(LongPressEndDetails)?;
            instance.onLongPressMoveUpdate = onLongPressMoveUpdate as void Function(LongPressMoveUpdateDetails)?;
            instance.onLongPressStart = onLongPressStart as void Function(LongPressStartDetails)?;
            instance.onLongPressUp = onLongPressUp as void Function()?;
            instance.onSecondaryLongPress = onSecondatyLongPress as void Function()?;
            instance.onSecondaryLongPressEnd = onSecondaryLongPressEnd as void Function(LongPressEndDetails)?;
            instance.onSecondaryLongPressMoveUpdate = onSecondaryLongPressMoveUpdate as void Function(LongPressMoveUpdateDetails)?;
            instance.onSecondaryLongPressStart = onSecondaryLongPressStart as void Function(LongPressStartDetails)?;
            instance.onSecondaryLongPressUp = onSecondaryLongPressUp as void Function()?;
            instance.onTertiaryLongPress = onTertiaryLongPress as void Function()?;
            instance.onTertiaryLongPressEnd = onTertiaryLongPressEnd as void Function(LongPressEndDetails)?;
            instance.onTertiaryLongPressStart = onTertiaryLongPressStart as void Function(LongPressStartDetails)?;
            instance.onTertiaryLongPressMoveUpdate = onTertiaryLongPressMoveUpdate as void Function(LongPressMoveUpdateDetails)?;
            instance.onTertiaryLongPressUp = onTertiaryLongPressUp as void Function()?;
          },
        ),
      },
    );
  }
}