import 'package:flutter/material.dart';

import 'package:flutter_qr_reader/flutter_qr_reader.dart';

import '../../../utils/navigator_utils.dart';
import '../../../utils/permission_utils.dart';
import '../../../widget/qrcode_reader_view.dart';

/// 扫码二维码
class ScanQrcodePage extends StatefulWidget {

  static const String routeName='/ScanQrcodePage';

  const ScanQrcodePage({Key? key}) : super(key: key);

  @override
  _ScanQrcodePageState createState() => _ScanQrcodePageState();
}

class _ScanQrcodePageState extends State<ScanQrcodePage> {
  bool _hasPermission = false;
  final GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  QrReaderViewController? _controller;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(),
      );
    }
    return Scaffold(
      body: QrcodeReaderView(
        key: _key,
        onScan: onScan,
      ),
    );
  }

   Future onScan(String? result) async {
    debugPrint('onScan $result');
    _controller?.stopCamera();
    NavigatorUtils.pop(result);
  }


  @override
  void dispose() {
    super.dispose();
  }

  void requestPermission() async {
    _hasPermission = await PermissionUtils.requestCameraPermission();
    if (!_hasPermission) {
      Navigator.of(context).pop();
    } else {
      setState(() {});
    }
  }
}
