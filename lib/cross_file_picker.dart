library cross_file_picker;

import 'package:cross_file/cross_file.dart';
import 'package:cross_file_picker/src/typedefs.dart';
import 'package:cross_file_picker/src/x_file_stream.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:flutter/foundation.dart';

export 'package:file_picker/file_picker.dart' show FileType;

/// Instance this class or use [CrossFilePicker.instance] to start working!
///
/// The [pickMultiFile] and [pickSingleFile] methods use [FilePicker]
/// The [pickSingleImage], [pickMultiImage] and [pickVideo] methods use [ImagePicker]
class CrossFilePicker {
  final _filePicker = FilePicker.platform;

  CrossFilePicker._();

  /// You can override this instance for your own tests
  static CrossFilePicker instance = CrossFilePicker._();

  /// Retrieve the singleton from this factory
  factory CrossFilePicker() => instance;

  /// See [FilePicker.pickFiles].
  /// Pick multiple files.
  /// On desktop and mobile platforms, this function uses the path to read the file.
  /// [allowWebStream] enables reading of streamed web files but only once.
  Future<List<XFile>> pickMultiFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
    bool allowCompression = false,
    bool allowWebStream = false,
    bool lockParentWindow = false,
  }) async {
    return await _pick(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      allowMultiple: true,
      allowWebStream: allowWebStream,
      lockParentWindow: lockParentWindow,
    );
  }

  /// See [FilePicker.pickFiles]. Pick single file
  /// On desktop and mobile platforms, this function uses the path to read the file.
  /// [allowWebStream] enables reading of streamed web files but only once.
  Future<XFile?> pickSingleFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    bool allowCompression = false,
    bool allowWebStream = false,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
    bool lockParentWindow = false,
  }) async {
    final files = await _pick(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      allowMultiple: false,
      allowWebStream: allowWebStream,
      lockParentWindow: lockParentWindow,
    );
    if (files.isEmpty) return null;
    return files.single;
  }

  /// See [FilePicker.clearTemporaryFiles]
  Future<bool> clearTemporaryFiles() async {
    final result = await _filePicker.clearTemporaryFiles();
    return result!;
  }

  /// See [FilePicker.getDirectoryPath]
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async {
    return await _filePicker.getDirectoryPath(
      dialogTitle: dialogTitle,
      lockParentWindow: lockParentWindow,
      initialDirectory: initialDirectory,
    );
  }

  /// See [FilePicker.getDirectoryPath]
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool lockParentWindow = false,
  }) async {
    return await _filePicker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      lockParentWindow: lockParentWindow,
    );
  }

  /// See [FilePicker.pickFiles]
  Future<List<XFile>> _pick({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
    bool allowCompression = false,
    required bool allowMultiple,
    bool allowWebStream = false,
    bool lockParentWindow = false,
  }) async {
    final files = await _filePicker.pickFiles(
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      allowMultiple: allowMultiple,
      withData: kIsWeb && !allowWebStream,
      withReadStream: kIsWeb && allowWebStream,
      lockParentWindow: lockParentWindow,
    );
    if (files == null) return const <XFile>[];
    return files.files.map<XFile>((file) {
      if (kIsWeb) {
        if (allowWebStream) {
          return XFilePicker(file);
        } else {
          return XFile.fromData(
            file.bytes!,
            path: file.path,
            name: file.name,
            length: file.size,
          );
        }
      } else {
        return XFile(
          file.path!,
          bytes: file.bytes,
          name: file.name,
          length: file.size,
        );
      }
    }).toList();
  }
}
