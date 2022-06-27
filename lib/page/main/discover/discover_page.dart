import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';

import '../../../language/strings.dart';
import '../widget/main_appbar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        Ids.discover.str(),
        _buildBody()
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colours.theme_color_3,
    );
  }
}
