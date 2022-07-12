import 'package:leancloud_official_plugin/leancloud_plugin.dart';

/// IM RedPacket Message
class RedPacketMessage extends TypedMessage {


  @override
  int get type => 1;

  /// To create a new [RedPacketMessage].
  RedPacketMessage() : super();

  /// To create a new [RedPacketMessage] with [text] content.
  RedPacketMessage.from({
    required String redPacketId,
    required String hint,
  }) {
    rawData['redPacketId'] = redPacketId;
    text = hint;
  }

  String get  hint => rawData['hint']??'';

}