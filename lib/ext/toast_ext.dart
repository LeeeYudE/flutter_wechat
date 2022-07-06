import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

extension ToastNullExt on String? {
  void toast() {
    if (this != null && this!.isNotEmpty) {
      SmartDialog.showToast(this!);
    }
  }
}

