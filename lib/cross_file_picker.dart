library cross_file_picker;

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart' as ip;

export 'package:file_picker/file_picker.dart' hide FilePicker, FilePickerResult, PlatformFile;
export 'package:image_picker/image_picker.dart' hide ImagePicker;

class CrossFilePicker {
  final _imagePicker = ip.ImagePicker();
  final _filePicker = fp.FilePicker.platform;

  CrossFilePicker._();

  static CrossFilePicker instance = CrossFilePicker._();

  factory CrossFilePicker() => instance;

  Future<List<XFile>> pickMultiFile({
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
  }) async {
    return await _pick(
      allowMultiple: true,
      type: type,
      allowedExtensions: allowedExtensions,
    );
  }

  Future<XFile?> pickSingleFile({
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
  }) async {
    final files = await _pick(
      allowMultiple: false,
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (files.isEmpty) return null;
    return files.single;
  }

  Future<List<XFile>> _pick({
    required bool allowMultiple,
    fp.FileType type = fp.FileType.any,
    List<String>? allowedExtensions,
    Function(fp.FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
  }) async {
    final files = await _filePicker.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      withData: kIsWeb,
      withReadStream: false,
    );
    if (files == null) return const <XFile>[];
    return files.files.map((file) {
      if (kIsWeb) {
        return XFile.fromData(
          file.bytes!,
          path: file.path,
          name: file.name,
          length: file.size,
        );
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

  Future<XFile?> pickSingleImage({
    required ip.ImageSource source,
    ip.CameraDevice preferredCameraDevice = ip.CameraDevice.rear,
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

  Future<XFile?> pickVideo({
    required ip.ImageSource source,
    ip.CameraDevice preferredCameraDevice = ip.CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    return await _imagePicker.pickVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
  }
}
