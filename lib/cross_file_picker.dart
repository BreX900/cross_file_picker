library cross_file_picker;

import 'package:cross_file/cross_file.dart';
import 'package:cross_file_picker/src/typedefs.dart';
import 'package:cross_file_picker/src/x_file_stream.dart';
import 'package:file_picker/file_picker.dart' show FilePicker, FileType;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, CameraDevice;

export 'package:file_picker/file_picker.dart' show FileType;
export 'package:image_picker/image_picker.dart' show ImageSource, CameraDevice;

/// Instance this class or use [CrossFilePicker.instance] to start working!
///
/// The [pickMultiFile] and [pickSingleFile] methods use [FilePicker]
/// The [pickSingleImage], [pickMultiImage] and [pickVideo] methods use [ImagePicker]
class CrossFilePicker {
  final _imagePicker = ImagePicker();
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
    FileType type = FileType.any,
    bool allowCompression = false,
    bool allowWebStream = false,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
  }) async {
    return await _pick(
      allowMultiple: true,
      type: type,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      allowedExtensions: allowedExtensions,
      allowWebStream: allowWebStream,
    );
  }

  /// See [FilePicker.pickFiles]. Pick single file
  /// On desktop and mobile platforms, this function uses the path to read the file.
  /// [allowWebStream] enables reading of streamed web files but only once.
  Future<XFile?> pickSingleFile({
    FileType type = FileType.any,
    bool allowCompression = false,
    bool allowWebStream = false,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
  }) async {
    final files = await _pick(
      allowMultiple: false,
      type: type,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      allowedExtensions: allowedExtensions,
      allowWebStream: allowWebStream,
    );
    if (files.isEmpty) return null;
    return files.single;
  }

  /// See [ImagePicker.pickImage]
  Future<XFile?> pickSingleImage({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return await _imagePicker.pickImage(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  /// See [ImagePicker.pickMultiImage]
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final list = await _imagePicker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return list ?? const [];
  }

  /// See [ImagePicker.pickVideo]
  Future<XFile?> pickVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    return await _imagePicker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
  }

  /// See [FilePicker.pickFiles]
  Future<List<XFile>> _pick({
    required bool allowMultiple,
    FileType type = FileType.any,
    bool allowCompression = false,
    bool allowWebStream = false,
    List<String>? allowedExtensions,
    OnFileLoading? onFileLoading,
  }) async {
    final files = await _filePicker.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      withData: kIsWeb && !allowWebStream,
      withReadStream: kIsWeb && allowWebStream,
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
