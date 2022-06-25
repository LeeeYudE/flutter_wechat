import 'dart:ui';

class LanguageModel {
  String? titleId;
  String? languageCode;
  String? countryCode;

  LanguageModel(this.titleId, this.languageCode, this.countryCode);

  LanguageModel.fromJson(Map<String?, dynamic> json)
      : titleId = json['titleId'],
        languageCode = json['languageCode'],
        countryCode = json['countryCode'];

  Map<String, dynamic> toJson() => {
    'titleId': titleId,
    'languageCode': languageCode,
    'countryCode': countryCode,
  };


  Locale toLocale() {
    return Locale(languageCode!, countryCode);
  }


  @override
  String toString() {
    final StringBuffer sb = StringBuffer('{');
    sb.write('"titleId":"$titleId"');
    sb.write(',"languageCode":"$languageCode"');
    sb.write(',"countryCode":"$countryCode"');
    sb.write('}');
    return sb.toString();
  }

  @override
  int get hashCode => titleId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is LanguageModel) {
      return other.titleId == titleId;
    }
    return super == other;
  }
}
