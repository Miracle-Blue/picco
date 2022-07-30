import 'package:flutter/material.dart';
import 'package:picco/models/home_model.dart';

class PropertyTypeProvider extends ChangeNotifier{
  int selectTypeHouseIndex = 0;
  String categoryType = 'house';


  final Map<String, String> data = {
    'Дом / квартира': 'assets/images/1.png',
    'Здание для бизнеса': 'assets/images/2.png',
    'Новостройки': 'assets/images/3.png',
    'Коттедж': 'assets/images/4.png',
    'Гостиницы': 'assets/images/5.png',
    'Загородные дома': 'assets/images/6.png',
  };


  void chooseHouseType(index) {
    selectTypeHouseIndex = index;
    categoryType = homeCategoryType[index];
    notifyListeners();
  }
}