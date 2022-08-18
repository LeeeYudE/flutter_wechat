import 'package:flutter/cupertino.dart';
import 'package:wechat/controller/chat_manager_controller.dart';
import 'package:wechat/page/main/contacts/contacts_page.dart';
import 'package:wechat/page/main/discover/discover_page.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/lazy_indexed_stack.dart';
import '../../controller/friend_controller.dart';
import '../../plugin/uniapp/uniapp_plugin_method_channel.dart';
import '../../utils/emoji_text.dart';
import 'chat/chat_list_page.dart';
import 'mine/mine_page.dart';
import 'widget/main_bottom_bar.dart';

class MainPage extends StatefulWidget {

  static const String routeName = '/MainPage';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    FriendController.instance.friendIndex();
    ChatManagerController.instance.initClient();
    _pages.add(const ChatListPage());
    _pages.add(ContactsPage());
    _pages.add(const DiscoverPage());
    _pages.add(MinePage());
    EmojiUtil.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      brightness: Brightness.dark,
      showAppbar: false,
      body: LazyIndexedStack(itemBuilder: (BuildContext context, int index) {
        return _pages[index];
      },itemCount: _pages.length,index: _currentIndex,
      ),
      bottomNavigationBar: MainBottomBar((index){
        setState((){
          _currentIndex = index;
        });
      }),
    );
  }

}
