
import 'package:path/path.dart';
import 'dart:io';

extension FileExt on File {

 String get filename => basename(path);

}