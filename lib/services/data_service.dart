import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/services/deep_link_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';

class FirestoreService {
  static final _instance = FirebaseFirestore.instance;

  static const String usersFolder = 'users';
  static const String homesFolder = 'homes';
  static const String adminFolder = 'adminHomes';
  static const String favoriteHomesFolder = 'favoriteHomes';

  // * User Related
  static Future<void> storeUser(UserModel user) async {
    Map<String, String> params = await Utils.deviceParams();
    user.deviceId = params['device_id']!;
    user.deviceType = params['device_type']!;
    user.deviceToken = params['device_token']!;

    await _instance.collection(usersFolder).doc(user.id).set(user.toJson());
  }

  static Future<void> storeFavoriteFolders(List favoriteHouses) async {
    final query =
        _instance.collection(favoriteHomesFolder).doc(HiveService.getUser().id);
    for (var folder in favoriteHouses) {
      await query
          .collection(folder.keys.first)
          .get()
          .then((QuerySnapshot snapshots) {
        for (DocumentSnapshot ds in snapshots.docs) {
          ds.reference.delete();
        }
      });
      for (Map<String, dynamic> houses in folder.values.first) {
        await query.collection(folder.keys.first).doc(houses["id"]).set(houses);
      }
    }

    await query.set({"favoriteHomes": favoriteHouses});
  }

  static Future<List?> getFavoriteHouses(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> query =
        await _instance.collection(favoriteHomesFolder).doc(userId).get();
    Map<String, dynamic>? json = query.data();
    return json == null ? null : json.values.first as List;
  }

  // * House Related
  static Future<void> storeHouse(HomeModel house) async {
    final query = _instance
        .collection(adminFolder)
        .doc(house.sellType)
        .collection(house.homeType);

    house.id = query.doc().id;

    house.deepLink = (await LinkService.createShortLink(house.id!)).toString();

    await query.doc(house.id).set(house.toJson());
  }

  static Future<void> updateHouse(HomeModel house) async {
    final query = _instance
        .collection(homesFolder)
        .doc(house.sellType)
        .collection(house.homeType);

    final queryToUser = _instance
        .collection(usersFolder)
        .doc(house.userId)
        .collection(homesFolder);

    await query.doc(house.id).update(house.toJson());
    await queryToUser.doc(house.id).update(house.toJson());
  }

  static Future<List<UserModel>> getUser() async {
    List<UserModel> users = [];
    var querySnapshot = await _instance.collection(usersFolder).get();

    for (var user in querySnapshot.docs) {
      users.add(UserModel.fromJson(user.data()));
    }

    return users;
  }

  static Future<List<HomeModel>> getHouses({
    required String sellType,
    required String categoryType,
  }) async {
    List<HomeModel> houses = [];

    var querySnapshot = await _instance
        .collection(homesFolder)
        .doc(sellType)
        .collection(categoryType)
        .get();

    for (var element in querySnapshot.docs) {
      houses.add(HomeModel.fromJson(element.data()));
    }

    return houses;
  }

  static Future<List<HomeModel>> getCountryHouses({
    required String sellType,
    required String categoryType,
  }) async {
    List<HomeModel> houses = [];

    var querySnapshot = await _instance
        .collection(homesFolder)
        .doc(sellType)
        .collection(categoryType)
        .get();
    // .startAt([country]).endAt([country + '\uf8ff']).get();

    for (var element in querySnapshot.docs) {
      houses.add(HomeModel.fromJson(element.data()));
    }

    return houses;
  }

  static Future<void> getFavoriteHouse(
      HomeModel home, List<String> favoriteFoldersList) async {
    // for(String folderName in favoriteFoldersList)
    // await _instance.collection(favoriteHomesFolder).doc(home.userId).collection(collectionPath)
  }

  static Future<void> deleteUser(String userId) async {
    await _instance.collection(usersFolder).doc(userId).delete();
  }

  static Future<void> deleteHouse(HomeModel house, String userId) async {
    await _instance
        .collection(homesFolder)
        .doc(house.sellType)
        .collection(house.homeType)
        .doc(house.id)
        .delete();
    await _instance
        .collection(usersFolder)
        .doc(userId)
        .collection(homesFolder)
        .doc(house.id)
        .delete();
  }
}
