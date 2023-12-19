import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

typedef StringCallback = void Function(String);

class ImageUtil {
  static Future<void> openFilePickerModal(
    BuildContext context,
    StringCallback callback,
    FileType type,
  ) async {
    // readImageRequest(
    //   context,
    //   () async {
    var image = await filePick(
      type: type,
    );
    if (image.isNotEmpty) {
      callback(image);
    }
    // },
    // );
  }

  static Future<String> filePick({
    required FileType type,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
    );
    return (result?.files.single.path ?? "");
  }
}
