import 'package:flutter/material.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isSeller = HiveService.getRole() == null
      ? false
      : HiveService.getRole() == "seller"
          ? true
          : false;

  changePageRoute() {
    isSeller = !isSeller;
    notifyListeners();
  }
}
