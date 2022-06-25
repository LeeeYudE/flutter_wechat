import 'package:flutter/material.dart';

/// @author Barry
/// @date 2020/9/4
/// describe:
///请使用这个解析的时候注意倒入的包名import 'package:business/utils/json_parse_utils.dart';
///而且可以通过https://fastcode555.github.io/#tools/Json2DartPage进行格式化
extension MapExt on Map? {
  //单字段解析
  String asString(String key) {
    if (this == null) {
      return '';
    }
    final Object? value = this![key];
    if (value == null) {
      return '';
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }

  //多字段解析
  String asStrings(List<String> keys) {
    if (this == null) {
      return '';
    }
    for (final String key in keys) {
      final Object? value = this![key];
      if (value == null) {
        continue;
      }
      if (value is String) {
        return value;
      }
    }
    return '';
  }

  double asDouble(String key) {
    if (this == null) {
      return 0.0;
    }
    final Object? value = this![key];
    if (value == null) {
      return 0.0;
    }
    if (value is double) {
      return value;
    }
    try {
      final double result = double.parse(value.toString());
      return result;
    } catch (e) {
      print(e);
      _print('json parse failed,exception value:\"$key\":$value');
    }
    return 0.0;
  }

  double asDoubles(List<String> keys) {
    if (this == null) {
      return 0.0;
    }
    for (final String key in keys) {
      final Object? value = this![key];
      if (value == null) {
        continue;
      }
      if (value is double) {
        return value;
      }
      try {
        final double result = double.parse(value.toString());
        return result;
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
      }
    }
    return 0.0;
  }

  int asInt(String key) {
    if (this == null) {
      return 0;
    }
    final Object? value = this![key];
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if(value is double){
      return value.toInt();
    }
    try {
      final int result = int.parse(value.toString());
      return result;
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":$value');
    }
    return 0;
  }

  int asInts(List<String> keys) {
    if (this == null) {
      return 0;
    }
    for (final String key in keys) {
      final Object? value = this![key];
      if (value == null) {
        continue;
      }
      if (value is int) {
        return value;
      }
      try {
        final int result = int.parse(value.toString());
        return result;
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
      }
    }
    return 0;
  }

  bool asBool(String key) {
    if (this == null) {
      return false;
    }
    final Object? value = this![key];
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value == 'true') {
      return true;
    }
    if (value == 'false') {
      return false;
    }
    _print('json parse failed,exception value::\"$key\":$value');
    return false;
  }

  num asNum(String key) {
    if (this == null) {
      return 0;
    }
    final Object? value = this![key];
    if (value == null) {
      return 0;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value;
    }
    try {
      if (value is String) {
        if (value.contains('.')) {
          return double.parse(value);
        } else {
          return int.parse(value);
        }
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":$value');
    }
    return 0;
  }

  Map? asMap(String key) {
    if (this == null) {
      return {};
    }
    final Object? value = this![key];
    if (value == null) {
      return null;
    }
    if (value is Map) {
      return value;
    }
    return null;
  }

/*
  Color asColor(String key) {
    Object? value = this[key];
    if (value == null) return Colors.amber;
    if (value is String) {
      try {
        String hexColor = value;
        if (hexColor.isEmpty) return Colors.amber;
        hexColor = hexColor.toUpperCase().replaceAll("#", "");
        hexColor = hexColor.replaceAll('0X', '');
        if (hexColor.length == 6) {
          hexColor = "FF" + hexColor;
        }
        return Color(int.parse(hexColor, radix: 16));
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":$value');
      }
    }
    return Colors.amber;
  }
*/

  List<T> asList<T>(
      String key, T Function(Map<String, dynamic> json)? toBean) {
    if (this == null) {
      return [];
    }
    try {
      if (toBean != null && this![key] != null) {
        return (this![key] as List).map((v) => toBean(v)).toList().cast<T>();
      } else if (this![key] != null) {
        return List<T>.from(this![key]);
      }
    } catch (e) {
      print('asList error $e');
      _print('json parse failed,exception value::\"$key\":${this![key]}');
      return [];
    }
    return [];
  }

  List<T>? asLists<T>(
      List<String> keys, Function(Map<String, dynamic> json)? toBean) {
    if (this == null) {
      return null;
    }
    for (final String key in keys) {
      try {
        if (this![key] != null) {
          if (toBean != null && this![key] != null) {
            return (this![key] as List)
                .map((v) => toBean(v))
                .toList()
                .cast<T>();
          } else {
            return List<T>.from(this![key]);
          }
        }
      } catch (e) {
        print(e);
        _print('json parse failed,exception value::\"$key\":${this![key]}');
      }
    }

    return null;
  }

  T? asBeans<T>(List<String> keys, Function(Map<String, dynamic> json) toBean) {
    if (this == null) {
      return null;
    }
    for (final String key in keys) {
      try {
        if (this![key] != null && _isClassBean(this![key])) {
          return toBean(this![key]);
        }
      } catch (e) {
        print(e);
        _print('json parse asBeans failed,exception value::\"$key\":${this![key]}');
      }
    }

    return null;
  }

  T? asBean<T>(String key, Function(Map<String, dynamic> json) toBean) {
    if (this == null) {
      return null;
    }
    try {
      if (this![key] != null && _isClassBean(this![key])) {
        return toBean(this![key]);
      }
    } catch (e) {
      print(e);
      _print('json parse failed,exception value::\"$key\":${this![key]}');
    }
    return null;
  }

  bool _isClassBean(Object obj) {
    bool isClassBean = true;
    if (obj is String || obj is num || obj is bool) {
      isClassBean = false;
    } else if (obj is Map && obj.isEmpty) {
      isClassBean = false;
    }
    return isClassBean;
  }

  void _print(String msg) {
    debugPrint(msg);
  }

  Map put(String key, Object? value) {
    if (value != null && value is String && value.isNotEmpty) {
      this![key] = value;
    } else if (value != null && value is! String) {
      this![key] = value;
    }
    return this!;
  }
}
