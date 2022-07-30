import 'package:hive/hive.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/services/log_service.dart';

enum StorageKeys { LANGUAGE }

class HiveService {
  static String DB_NAME = 'picco';
  static Box box = Hive.box(DB_NAME);

  static String key(StorageKeys key) {
    switch (key) {
      case StorageKeys.LANGUAGE:
        return 'language';
    }
  }

  /// FOR A STRING
  static Future<void> storeString(String key, String data) async {
    box.put(key, data);
  }

  static String loadString(String key) {
    String data = box.get(key, defaultValue: '');
    return data;
  }

  static Future<void> removeString(String key) async {
    box.delete(key);
  }

  /// FOR A LIST
  static Future<void> storeData(String key, List data) async {
    await box.put(key, data);
  }

  static List loadData(String key) {
    List data = box.get(key, defaultValue: []);
    return data;
  }

  static Future<void> removeData(String key) async {
    await box.delete(key);
  }

  static saveUser(UserModel user) {
    box.put("id", user.id);
    box.put("fullName", user.fullName);
    box.put("password", user.password);
    box.put("phoneNumber", user.phoneNumber);
    box.put("email", user.email);
    box.put("role", user.role);
  }

  static UserModel getUser() {
    String? id = box.get("id", defaultValue: null);
    String? fullName = box.get("fullName", defaultValue: null);
    String? password = box.get("password", defaultValue: null);
    String? phoneNumber = box.get("phoneNumber", defaultValue: null);
    String? email = box.get("email", defaultValue: null);
    String? role = box.get("role", defaultValue: null);

    return UserModel(
      id: id,
      fullName: fullName,
      password: password,
      phoneNumber: phoneNumber,
      email: email,
      role: role,
    );
  }

  static void removeUser() {
    box.delete("id");
    box.delete("fullName");
    box.delete("password");
    box.delete("phoneNumber");
    box.delete("email");
    box.delete("role");
  }

  static String? getRole() {
    String? role = box.get("role", defaultValue: null);
    return role;
  }
}
