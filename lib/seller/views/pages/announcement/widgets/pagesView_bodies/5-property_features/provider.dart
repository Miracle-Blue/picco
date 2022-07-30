import 'dart:async';

import 'package:flutter/material.dart';

class PropertyFeaturesProvider extends ChangeNotifier{

 int callsCount = 0;
 int allViews = 0;
 int smsCount = 0;

  int bedsNumber = 0;
  bool bedsNumberExceeded = false;
  int bathsNumber = 0;
  bool bathsNumberExceeded = false;
  int roomsNumber = 0;
  bool roomsNumberExceeded = false;
  double homeArea = 0.0;
  bool homeAreaExceeded = false;

  Timer? timer;
  bool longPressCanceled = false;

  updateBeds(int value) {
    if (value >= 0 && value < 10) {
      bedsNumber = value;
      bedsNumberExceeded = false;
      notifyListeners();
    }else if(value >= 10){
      bedsNumberExceeded = true;
      notifyListeners();
    }
  }

  updateBath(int value) {
    if (value >= 0 && value < 10) {
      bathsNumber = value;
      bathsNumberExceeded = false;
      notifyListeners();
    }else if(value >= 10){
      bathsNumberExceeded = true;
      notifyListeners();
    }
  }

  updateRooms(int value) {
    if (value >= 0 && value < 10) {
      roomsNumber = value;
      roomsNumberExceeded = false;
      notifyListeners();
    }else if(value >= 10){
      roomsNumberExceeded = true;
      notifyListeners();
    }
  }

  void updateHomeArea(double value) {
    if (value >= 0.0 && value <= 1000.0) {
      homeArea = value;
      homeAreaExceeded = false;
      notifyListeners();
    }else if(value > 1000.0){
      homeAreaExceeded = true;
      notifyListeners();
    }
  }

 void cancelUpdatingHomeArea() {
   if (timer != null) {
     timer!.cancel();
   }
   longPressCanceled = true;
 }
}