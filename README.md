# cross_file_picker

A package that allows you to use the native file explorer to pick single or multiple files/image/video, with extensions filtering support.

This package exposes some libraries integrated with `XFile` class of [cross_file](https://pub.dev/packages/cross_file)

This package uses the interfaces of:
- [photo_picker package](https://pub.dev/packages/image_picker)
- [file_picker package](https://pub.dev/packages/file_picker)

## Usage

Import the base library you want to use into your pubspec:

| package | original methods | new methods |
| --- | --- | --- |
| file_picker | `pickFiles` | `pickMultiFile` `pickMultiFile` | 
| image_picker | `pickImage` `pickMultiImage` | `pickSingleImage` `pickSingleImage` |

## More

This package can be used with [flutter_ui_bloc](https://pub.dev/packages/flutter_ui_bloc) to manage `FieldBloc` class
with [form_bloc](https://pub.dev/packages/form_bloc) package.