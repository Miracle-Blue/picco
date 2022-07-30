import 'package:flutter/material.dart';
import 'package:picco/services/log_service.dart';

class PropertyBenefitsProvider extends ChangeNotifier {

  final Map<String, String> media = {
    'assets/icons/announcement_page_icons/kitchen_facility.png': 'Кухонная мебель',
    'assets/icons/announcement_page_icons/sofa.png': 'Мебель в комнатах',
    'assets/icons/announcement_page_icons/fridge.png': 'Холодильник',
    'assets/icons/announcement_page_icons/washing_machine.png': 'Стиральная машина',
    'assets/icons/announcement_page_icons/tv.png': 'Телевизор',
    'assets/icons/announcement_page_icons/wifi.png': 'Интернет',
    'assets/icons/announcement_page_icons/air_conditioner.png': 'Кондиционер',
    'assets/icons/announcement_page_icons/dish_washer.png': 'Посудомоечная машина',
    'assets/icons/announcement_page_icons/bath.png': 'Душевая кабина',
    'assets/icons/announcement_page_icons/baby.png': 'Можно с детьми',
    'assets/icons/announcement_page_icons/animals.png': 'Домашние животные разрешены',
  };

  final Map< String, bool> facilities = {
    'Кухонная мебель' : false,
    'Мебель в комнатах' : false,
    'Холодильник' : false,
    'Стиральная машина': false,
    'Телевизор': false,
    'Интернет' : false,
    'Кондиционер' : false,
    'Посудомоечная машина' : false,
    'Душевая кабина' : false,
    'Можно с детьми' : false,
    'Домашние животные разрешены' : false,
  };

  // List<bool> listFacilities = [
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  // ];

  void updateFacilities(int index) {
    facilities[facilities.keys.toList()[index]] = !facilities.values.toList()[index];
    notifyListeners();
  }
}