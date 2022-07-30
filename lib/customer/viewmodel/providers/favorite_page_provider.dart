import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';

class FavoritePageProvider extends ChangeNotifier{
  
  late HomeModel home;

  getFavoriteHouses(String nameFolder){
    return FirebaseFirestore.instance
        .collection(FirestoreService.favoriteHomesFolder)
        .doc(HiveService.getUser().id!)
        .collection(nameFolder)
        .snapshots();
  }

  catchHouse({required jsonHome}){
     home = HomeModel(
      userId: jsonHome["userId"],
      sellType: jsonHome["sellType"],
      homeType: jsonHome["homeType"],
      city: jsonHome["city"],
      district: "district",
      street: "street",
      price: jsonHome["price"],
      definition: jsonHome["definition"],
      geo: Geo.fromJson(jsonHome["geo"]),
      houseFacilities: List<bool>.from(jsonHome['houseFacilities']),
      bedsCount: jsonHome["bedsCount"],
      bathCount: jsonHome["bathCount"],
      roomsCount: jsonHome["roomsCount"],
      houseArea: jsonHome["houseArea"],
      callsCount: jsonHome["callsCount"],
      allViews: jsonHome["allViews"],
      smsCount: jsonHome["smsCount"],
      pushedDate: jsonHome["pushedDate"],
      houseImages: List<String>.from(jsonHome['houseImages']),
    );
     notifyListeners();
  } 
}
