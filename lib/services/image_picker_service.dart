import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picco/services/utils.dart';

import 'log_service.dart';

final pickerService = PickerService();

class PickerService {
  Future<List<XFile>?> getPickedImages() async {
    try {
      final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        return selectedImages;
      } else {
        Log.i("Not selected Image");
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  Future<File?> getImage(context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      Utils.fireSnackBar(
          normalText: "No image selected", redText: "", context: context);
    }
    return null;
  }

  Future<XFile?> openPicker(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        return image;
      } else {
        Log.i("Not selected Image");
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }
}
