import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
// ignore: implementation_imports
import 'package:cross_file/src/types/base.dart';

class XFileStream extends XFileBase implements XFile {
  final Stream<List<int>> readStream;
  final String? _name;
  final String? _path;
  final int? _length;

  XFileStream(
    this.readStream, {
    String? path,
    String? name,
    int? length,
  })  : _path = path,
        _name = name,
        _length = length,
        super(null);

  @override
  String get path => _path!;

  @override
  String get name => _name!;

  @override
  Future<int> length() async => _length!;

  String? get mimeType => null;

  Future<Uint8List> readAsBytes() async {
    final bytes = await readStream.toList();
    return Uint8List.fromList(bytes.expand((element) => element).toList());
  }

  Stream<Uint8List> openRead([int? start, int? end]) {
    return readStream.map((bytes) => Uint8List.fromList(bytes));
  }
}
