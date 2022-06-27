import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat/core.dart';
import 'dart:math' as math;

/// 使用前需已经获取相关权限
/// Relevant privileges must be obtained before usez
class QrcodeReaderView extends StatefulWidget {
  final Widget? headerWidget;
  final Future Function(String?) onScan;
  final double scanBoxRatio;
  final Color boxLineColor;
  final Widget? helpWidget;
  final bool photo; //true:显示从相册导入

  const QrcodeReaderView({
    Key? key,
    required this.onScan,
    this.headerWidget,
    this.boxLineColor = Colors.cyanAccent,
    this.helpWidget,
    this.scanBoxRatio = 0.85,
    this.photo = true,
  }) : super(key: key);

  @override
  QrcodeReaderViewState createState() => QrcodeReaderViewState();
}

/// 扫码后的后续操作
/// ```dart
/// GlobalKey<QrcodeReaderViewState> qrViewKey = GlobalKey();
/// qrViewKey.currentState.startScan();
/// ```
class QrcodeReaderViewState extends State<QrcodeReaderView>
    with TickerProviderStateMixin {
  late QrReaderViewController _controller;
  AnimationController? _animationController;
  bool? openFlashlight;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    openFlashlight = false;
    _initAnimation();
  }

  void _initAnimation() {
    setState(() {
      _animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000));
    });
    _animationController!
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(const Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(const Duration(seconds: 1), () {
            _animationController?.forward(from: 0.0);
          });
        }
      });
    _animationController!.forward(from: 0.0);
  }

  void _clearAnimation() {
    _timer?.cancel();
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  void _upState() {
    setState(() {});
  }

  void _onCreateController(QrReaderViewController controller) async {
    _controller = controller;
    // _controller.onQrBack = _onQrBack;
    // _controller.stopCamera();
    _controller.startCamera(_onQrBack);
  }

  bool isScan = false;

  Future _onQrBack(data, _) async {
    if (isScan == true) return;
    isScan = true;
    stopScan();
    await widget.onScan(data);
  }

  void startScan() {
    isScan = false;
    _controller.startCamera(_onQrBack);
    _initAnimation();
  }

  void stopScan() {
    _clearAnimation();
    _controller.stopCamera();
  }

  Future<bool?> setFlashlight() async {
    openFlashlight = await _controller.setFlashlight();
    setState(() {});
    return openFlashlight;
  }

  Future _scanImage() async {
    stopScan();
    var pickedFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      startScan();
      return;
    }
    final rest = await FlutterQrReader.imgScan(pickedFile.path);
    await widget.onScan(rest);
    startScan();
  }

  @override
  Widget build(BuildContext context) {
    final flashOpen = Image.asset(
      "assets/images/scan/tool_flashlight_open.png",
      width: 40.w,
      height: 40.w,
      color: Colors.white,
    );
    final flashClose = Image.asset(
      "assets/images/scan/tool_flashlight_close.png",
      width: 40.w,
      height: 40.w,
      color: Colors.white,
    );
    return Material(
      color: Colors.black,
      child: LayoutBuilder(builder: (context, constraints) {
        final qrScanSize = constraints.maxWidth * widget.scanBoxRatio;
        final mediaQuery = MediaQuery.of(context);
        if (constraints.maxHeight < qrScanSize * 1.5) {
          debugPrint("建议高度与扫码区域高度比大于1.5");
        }
        return Stack(
          children: <Widget>[
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: QrReaderView(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                callback: _onCreateController,
              ),
            ),
            if (widget.headerWidget != null) widget.headerWidget!,
            Positioned(
              left: (constraints.maxWidth - qrScanSize) / 2,
              top: (constraints.maxHeight - qrScanSize) * 0.333333,
              child: CustomPaint(
                painter: QrScanBoxPainter(
                  boxLineColor: widget.boxLineColor,
                  animationValue: _animationController?.value ?? 0,
                  isForward:
                      _animationController?.status == AnimationStatus.forward,
                ),
                child: SizedBox(
                  width: qrScanSize,
                  height: qrScanSize,
                ),
              ),
            ),
            Positioned(
              top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                  qrScanSize +
                  24,
              width: constraints.maxWidth,
              child: Align(
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: widget.helpWidget ?? const Text("请对准二维码进行扫描"),
                ),
              ),
            ),
            Positioned(
              top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                  qrScanSize -
                  12 -
                  35,
              width: constraints.maxWidth,
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: setFlashlight,
                  child: openFlashlight! ? flashOpen : flashClose,
                ),
              ),
            ),
            if (widget.photo)
              Positioned(
                width: constraints.maxWidth,
                bottom: constraints.maxHeight == mediaQuery.size.height
                    ? 12 + mediaQuery.padding.top
                    : 12,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _scanImage,
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/scan/tool_img.png",
                          width: 40.w,
                          height: 40.w,
                          color: Colors.white54,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            "从相册导入",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (!widget.photo)
              const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _clearAnimation();
    super.dispose();
  }
}

class QrScanBoxPainter extends CustomPainter {
  final double animationValue;
  final bool isForward;
  final Color? boxLineColor;

  QrScanBoxPainter(
      {required this.animationValue,
      required this.isForward,
      this.boxLineColor})
      : assert(animationValue != null),
        assert(isForward != null);

  @override
  void paint(Canvas canvas, Size size) {
    final borderRadius = const BorderRadius.all(Radius.circular(12)).toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRRect(
      borderRadius,
      Paint()
        ..color = Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = new Path();
    // leftTop
    path.moveTo(0, 50);
    path.lineTo(0, 12);
    path.quadraticBezierTo(0, 0, 12, 0);
    path.lineTo(50, 0);
    // rightTop
    path.moveTo(size.width - 50, 0);
    path.lineTo(size.width - 12, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 12);
    path.lineTo(size.width, 50);
    // rightBottom
    path.moveTo(size.width, size.height - 50);
    path.lineTo(size.width, size.height - 12);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 12, size.height);
    path.lineTo(size.width - 50, size.height);
    // leftBottom
    path.moveTo(50, size.height);
    path.lineTo(12, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 12);
    path.lineTo(0, size.height - 50);

    canvas.drawPath(path, borderPaint);

    canvas.clipRRect(
        const BorderRadius.all(Radius.circular(12)).toRRect(Offset.zero & size));

    // 绘制横向网格
    final linePaint = Paint();
    final lineSize = size.height * 0.45;
    final leftPress = (size.height + lineSize) * animationValue - lineSize;
    linePaint.style = PaintingStyle.stroke;
    linePaint.shader = LinearGradient(
      colors: [Colors.transparent, boxLineColor!],
      begin: isForward ? Alignment.topCenter : const Alignment(0.0, 2.0),
      end: isForward ? const Alignment(0.0, 0.5) : Alignment.topCenter,
    ).createShader(Rect.fromLTWH(0, leftPress, size.width, lineSize));
    for (int i = 0; i < size.height / 5; i++) {
      canvas.drawLine(
        Offset(
          i * 5.0,
          leftPress,
        ),
        Offset(i * 5.0, leftPress + lineSize),
        linePaint,
      );
    }
    for (int i = 0; i < lineSize / 5; i++) {
      canvas.drawLine(
        Offset(0, leftPress + i * 5.0),
        Offset(
          size.width,
          leftPress + i * 5.0,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(QrScanBoxPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;

  @override
  bool shouldRebuildSemantics(QrScanBoxPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
