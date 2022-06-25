import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

extension ToastNullExt on String? {
  void toast() {
    if (this != null && this!.isNotEmpty) {
      SmartDialog.showToast(this!);
    }
  }
}

extension ToastExt on String {
  ///复制到粘贴吧
  void copy2Clipboard() {
    debugPrint('copy=>$this');
    Clipboard.setData(ClipboardData(text: this));
    '复制成功'.toast();
  }
}
