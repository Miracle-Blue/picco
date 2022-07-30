import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';

class AnnouncementProvider extends ChangeNotifier {
  final pageController = PageController();
  int currentPageIndex = 0;
  int previousPageIndex = 0;

  bool isLoading = false;

  List<double> heights = [
    0.47.sh, // 1 - intro page
    0.43.sh, // 2 - sale types page
    0.6.sh, // 3 - property types
    0.4.sh, // 4 - address page
    0.40.sh, // 5 - property features
    0.6.sh, // 6 - property benefits page
    0.35.sh, // 7 - image upload page
    0.7.sh, // 8 - image view page
    0.55.sh, // 9 - title page
    0.5.sh, // 10 - price page
    0.84.sh, // 11 - overview page
  ];

  List<String> headers = [
    'С возвращением,\nЖасурбек',
    'Чего вы предлогаете и каком типе хотите вести продажу?',
    'Какой у вас жильё?',
    'Чего вы предлогаете и каком типе хотите вести продажу?',
    'Раскажите гостям о примуществах ващего жиля?',
    'Раскажите гостям о примуществах ващего жиля?',
    'Добавить фото жиля',
    'Добавить фото жиля',
    'Довайте придумаем яркий заголовок',
    'Довайте установим цену',
    '',
  ];

  void updatePageIndex(index) async {
    previousPageIndex = currentPageIndex;
    currentPageIndex = index;
    notifyListeners();

    debugPrint('*********************************************');
    debugPrint(
        'CurrentPage: $currentPageIndex | PreviousPage: $previousPageIndex');
    debugPrint('*********************************************');
  }

  void uploadIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

// #Double tap to exit
  Future<bool> onWillPopFunction() async {
    DateTime? lastPressed;
    final now = DateTime.now();
    const maxDuration = Duration(seconds: 2);
    final isWarning =
        lastPressed == null || now.difference(lastPressed) > maxDuration;

    if (isWarning) {
      lastPressed = DateTime.now();
      return false;
    }
    return true;
  }

  bool checkMapSelect(bool isDisable,bool streetIsEmpty) {
    return currentPageIndex == 3 && isDisable && streetIsEmpty;
  }

  bool checkImageIsNull(ImageUploadProvider imageUploadProvider) {
    return currentPageIndex == 6 &&
        imageUploadProvider.imagesDownloadUrls.isEmpty;
  }
}
