library cross_file_picker;

import 'package:cross_file/cross_file.dart';
import 'package:cross_file_picker/src/x_file_stream.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_picker/image_picker.dart' as ip;

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
    bool withData = false,
    bool withReadStream = false,
  }) async {
    final files = await _filePicker.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
      onFileLoading: onFileLoading,
      allowCompression: allowCompression,
      withData: withData,
      withReadStream: withReadStream,
    );
    if (files == null) return const <XFile>[];
    return files.files.map((file) {
      if (file.bytes != null) {
        return XFile.fromData(file.bytes!, name: file.name, length: file.size, path: file.path);
      } else if (file.path != null) {
        return XFile(file.path!, name: file.name, length: file.size, bytes: file.bytes);
      } else if (file.readStream != null) {
        return XFileStream(file.readStream!, path: file.path, name: file.name, length: file.size);
      } else {
        throw throw UnimplementedError('.path has not been implemented.');
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
    final file = await _imagePicker.getImage(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    if (file == null) return null;
    return XFile(file.path);
  }

  Future<XFile?> pickVideoImage({
    required ip.ImageSource source,
    ip.CameraDevice preferredCameraDevice = ip.CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    final file = await _imagePicker.getVideo(
      source: source,
      preferredCameraDevice: preferredCameraDevice,
      maxDuration: maxDuration,
    );
    if (file == null) return null;
    return XFile(file.path);
  }
}
