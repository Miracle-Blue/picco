import 'package:flutter/material.dart';
import 'package:picco/services/log_service.dart';

class SetPriceProvider extends ChangeNotifier{
  int price = 0;
  final priceController = TextEditingController(text: '0');
  final priceFocus = FocusNode();

  void updatePriceByTyping() {
    price = int.tryParse(priceController.text) ?? 0;
    notifyListeners();
  }

  void updatePriceByPressing(bool isIncreased) {
    if (isIncreased) {
      priceController.text =
          (int.tryParse(priceController.text)! + 5).toString();
      price = int.tryParse(priceController.text) ?? 0;
    } else {
      if (int.tryParse(priceController.text)! - 5 >= 0) {
        priceController.text =
            (int.tryParse(priceController.text)! - 5).toString();
        price = int.tryParse(priceController.text) ?? 0;
      }
    }
    notifyListeners();

    Log.d('OnPressed: $price');
  }
}