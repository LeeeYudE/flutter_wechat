import 'dart:typed_data';

///https://github.com/vandadnp/flutter-tips-and-tricks#section-titles-on-listview-in-flutter
extension Unwrap<T> on List<T?>? {
  List<T> unwrap() => (this ?? []).whereType<T>().toList();
}

extension ListExt<T> on List<T> {

  void forEachIndex(void Function(int index, T value) action) {
    asMap().forEach(action);
  }

  bool hasIndex(bool Function(T element) test) {
    return indexWhere(test) != -1;
  }

  T? itemWhere(bool Function(T element) test) {
    var _indexWhere = indexWhere(test);
    return _indexWhere != -1?this[_indexWhere]:null;
  }

  T? safetyItem(int index){
    if(index < 0 || index > length - 1){
      return null;
    }
    return this[index];
  }

}

extension AsciiCode on List<int> {
  ///获取当前字节码的 ascii码
  String get ascii => String.fromCharCodes(Uint8List.fromList(this));
}
