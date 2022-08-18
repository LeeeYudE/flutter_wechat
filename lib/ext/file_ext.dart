
import 'package:path/path.dart';
import 'dart:io';

extension FileExt on File {

 String get filename => basename(path);

 String get suffix => path.substring(path.lastIndexOf('.')).replaceAll('.', '');



}