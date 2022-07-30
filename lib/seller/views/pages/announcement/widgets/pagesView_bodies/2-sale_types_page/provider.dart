import 'package:flutter/material.dart';
import 'package:picco/models/home_model.dart';

class SaleTypesProvider extends ChangeNotifier{
  int selectTypeSaleIndex = 0;
  String sellType = 'buy_houses';

  final List<Map<String, String>> data = [
    {
      'Сдать в аренду жильё': 'Сдать в аренду многокомнатную квартиру, отель или место для бизнеса'
    },
      {'Продать жильё': 'Продать многокомнатную квартиру, зданию или участок'},
    ];

  void chooseSaleType(index) {
    selectTypeSaleIndex = index;
    sellType = homeSellType[index];
    notifyListeners();
  }
}