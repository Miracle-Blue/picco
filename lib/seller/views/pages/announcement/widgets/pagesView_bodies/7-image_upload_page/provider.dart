import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picco/services/image_picker_service.dart';
import 'package:picco/services/store_service.dart';

class ImageUploadProvider extends ChangeNotifier {

  final Map<String, String> media = {
    'assets/icons/announcement_page_icons/photo_upload.png': 'Загрузить фото',
    'assets/icons/announcement_page_icons/photo_take.png': 'Сделать новое фото',
  };

  bool showLottie = false;
  Map<int, bool> changeColorForSelectedImage = {
    -1: false,
    0: false,
    1: false,
    2: false,
    3: false,
  };
  bool showCheckLottie = false;
  var images = <XFile>[];
  List<String> imagesDownloadUrls = [];

  Future<void> storeImagesToFirebaseStorage() async {
    imagesDownloadUrls.clear();

    if (images.isNotEmpty) {
      final List<File> listOfImages = images.map((e) => File(e.path)).toList();

      for (int i = 0; i < listOfImages.length; i++) {
        if (i < 5) {
          final downloadUrlLink =
              await StoreService.uploadFile(listOfImages[i]);

          if (downloadUrlLink != null) {
            imagesDownloadUrls.add(downloadUrlLink);
          }
        }
      }
    }
    showLottie = false;
    showCheckLottie = true;
    notifyListeners();

    imagesDownloadUrls.forEach(print);
  }

  Future<void> getSingleFileImages(int index) async {
    final image = (await pickerService.openPicker(ImageSource.gallery));

    changeColorForSelectedImage[index] = true;
    notifyListeners();

    if (image != null) {
      await storeImageToFirebase(image);
    }

    changeColorForSelectedImage[index] = false;
    notifyListeners();
  }

  Future<void> storeImageToFirebase(XFile image) async {
    final File fileImage = File(image.path);

    final downloadUrlLink = await StoreService.uploadFile(fileImage);

    if (downloadUrlLink != null) {
      imagesDownloadUrls.add(downloadUrlLink);
    }
    notifyListeners();

    imagesDownloadUrls.forEach(print);
  }

  Future<void> getFileImages() async {
    images = (await pickerService.getPickedImages()) ?? <XFile>[];
    showLottie = true;
    notifyListeners();

    await storeImagesToFirebaseStorage();
  }

  Future<void> getNeededImage() async {
    images = (await pickerService.getPickedImages()) ?? <XFile>[];

    for (int i = 0; i <= images.length; i++) {
      if (imagesDownloadUrls.length <= i) {
        changeColorForSelectedImage[i - 1] = true;
        notifyListeners();
      }
    }

    await storeNeededImagesToFireBase();
  }

  Future<void> storeNeededImagesToFireBase() async {
    if (images.isNotEmpty) {
      final List<File> listOfImages = images.map((e) => File(e.path)).toList();

      for (int i = 0; i < listOfImages.length; i++) {
        if (imagesDownloadUrls.length < 5) {
          final downloadUrlLink =
              await StoreService.uploadFile(listOfImages[i]);

          if (downloadUrlLink != null) {
            imagesDownloadUrls.add(downloadUrlLink);
          }
        }
      }
    }
    notifyListeners();

    imagesDownloadUrls.forEach(print);
  }

  void changeImageIndexToTop(int index) {
    String image = imagesDownloadUrls[0];
    imagesDownloadUrls[0] = imagesDownloadUrls[index + 1];
    imagesDownloadUrls[index + 1] = image;

    notifyListeners();
  }

  void deleteImage(int index) {
    changeColorForSelectedImage[imagesDownloadUrls.length - 2] = false;
    imagesDownloadUrls.removeAt(index + 1);
    notifyListeners();
  }

  Future<void> getCameraImage() async {
    XFile? cameraImage = await pickerService.openPicker(ImageSource.camera);

    if (cameraImage != null) {
      images.add(cameraImage);
      showLottie = true;
      notifyListeners();

      await storeImagesToFirebaseStorage();
    }
  }

  void clear() async {
    for(var url in imagesDownloadUrls) {
      await StoreService.deleteFile(url);
    }
  }

  runBottomSheet(BuildContext context, builder) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => builder,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.r),
        ),
      ),
    );
  }
}
