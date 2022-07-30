import 'package:flutter/cupertino.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/log_service.dart';

class HomeProvider extends ChangeNotifier{
  int selectCategoryIndex = 0;
  Future<void> getHousesFromFirebase() async {
    homes = await FirestoreService.getCountryHouses(
      sellType: 'buy_houses',
      categoryType: 'house',
    );
    notifyListeners();

    for (var element in homes) {
      Log.e(element.toString());
    }
  }

  updateCategory(int index){
    selectCategoryIndex = index;
    notifyListeners();
  }
}