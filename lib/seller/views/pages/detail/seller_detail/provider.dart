import 'package:flutter/material.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/store_service.dart';

class SellerDetailProvider extends ChangeNotifier {
  int showConvenienceCount = 4;
  bool isLoading = false;

  final facilityIcons = [
    'assets/icons/announcement_page_icons/kitchen_facility.png',
    'assets/icons/announcement_page_icons/sofa.png',
    'assets/icons/announcement_page_icons/fridge.png',
    'assets/icons/announcement_page_icons/washing_machine.png',
    'assets/icons/announcement_page_icons/tv.png',
    'assets/icons/announcement_page_icons/wifi.png',
    'assets/icons/announcement_page_icons/air_conditioner.png',
    'assets/icons/announcement_page_icons/dish_washer.png',
    'assets/icons/announcement_page_icons/bath.png',
    'assets/icons/announcement_page_icons/baby.png',
    'assets/icons/announcement_page_icons/animals.png',
  ];

  final facilityNames = [
    'Кухонный мебель',
    'Мебель в комнатах',
    'Холодильник',
    'Стиральная машина',
    'Телевизор',
    'Internet',
    'Кондитционер',
    'Посудамойка',
    'Душевая кабина',
    'Можно с детми',
    'Можно с животными',
  ];

  void updateShowConvenienceCount(int facilityCount) {
    showConvenienceCount = facilityCount;
    notifyListeners();
  }

  void updateIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> deleteHouse(HomeModel home) async {
    isLoading = true;
    notifyListeners();
    await FirestoreService.deleteHouse(home, HiveService.getUser().id!);
    for (var url in home.houseImages) {
      await StoreService.deleteFile(url);
    }
    isLoading = false;
    notifyListeners();
  }
}
