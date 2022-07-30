import 'package:flutter/material.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/10-price_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/2-sale_types_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/3-property_types/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/5-property_features/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/6-property_benefits_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/9-title_page/provider.dart';
import 'package:picco/services/data_service.dart';
import 'package:provider/provider.dart';

class OverviewAnnouncementProvider extends ChangeNotifier {
  final pageController = PageController();
  int currentPage = 0;

  void moveLeft(int length) {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
    if (currentPage == 0) {
      pageController.animateToPage(
        length - 1,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      );
      currentPage = length;
    }
  }

  void moveRight(int length) {
    if (currentPage < length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
    if (currentPage == length - 1) {
      pageController.animateToPage(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      );
      currentPage = 0;
    }
  }

  void changedPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Future<void> sendHouseToFirebaseFirestore(BuildContext context) async {
    var stringList = DateTime.now().toIso8601String().split(RegExp(r"[T\.]"));
    var formatOfDate = "${stringList[0]} ${stringList[1]}";



    final houseModel = HomeModel(
      userId: context.read<UserProvider>().user.id!,
      sellType: context.read<SaleTypesProvider>().sellType,
      homeType: context.read<PropertyTypeProvider>().categoryType,
      city: addressPageProvider.city,
      district: addressPageProvider.region,
      street: addressPageProvider.street,
      price: context.read<SetPriceProvider>().price.toString(),
      definition: context.read<SetTitleProvider>().title,
      geo: Geo(
        latitude: addressPageProvider.lat,
        longitude: addressPageProvider.lng,
      ),
      houseFacilities:
          context.read<PropertyBenefitsProvider>().facilities.values.toList(),
      bedsCount: context.read<PropertyFeaturesProvider>().bedsNumber.toString(),
      bathCount:
          context.read<PropertyFeaturesProvider>().bathsNumber.toString(),
      roomsCount:
          context.read<PropertyFeaturesProvider>().roomsNumber.toString(),
      houseArea: context.read<PropertyFeaturesProvider>().homeArea.toString(),
      callsCount: context.read<PropertyFeaturesProvider>().callsCount,
      allViews: context.read<PropertyFeaturesProvider>().allViews,
      smsCount: context.read<PropertyFeaturesProvider>().smsCount,
      houseImages: context.read<ImageUploadProvider>().imagesDownloadUrls,
      pushedDate: formatOfDate,
    );

    await FirestoreService.storeHouse(houseModel);
  }
}
