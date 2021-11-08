import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
// ignore: implementation_imports
import 'package:cross_file/src/types/base.dart';
import 'package:file_picker/file_picker.dart';

class XFilePicker extends XFileBase implements XFile {
  final PlatformFile file;

  XFilePicker(this.file) : super(null);

  @override
  String get path => file.path!;

  @override
  String get name => file.name;

  @override
  Future<int> length() async => file.size;

  String? get mimeType => null;

  Future<Uint8List> readAsBytes() async {
    final bytes = await file.readStream!.toList();
    return Uint8List.fromList(bytes.expand((element) => element).toList());
  }

  Stream<Uint8List> openRead([int? start, int? end]) {
    return file.readStream!.map((bytes) => Uint8List.fromList(bytes));
  }
}
