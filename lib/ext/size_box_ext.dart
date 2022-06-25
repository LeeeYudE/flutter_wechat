import 'package:flutter/cupertino.dart';

import 'screen_util_ext.dart';

extension SizeboxExt on int {
  Widget get sizedBoxH {
    return SizedBox(
      height: h,
    );
  }

  Widget get sizedBoxW {
    return SizedBox(
      width: w,
    );
  }
}
