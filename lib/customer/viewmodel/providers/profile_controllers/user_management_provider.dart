import 'package:flutter/material.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';

class UserManagementProvider extends ChangeNotifier {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isActive = false;

  onTapTextField() {
    isActive = true;
    notifyListeners();
  }

  Future<void> onSave(UserProvider userProvider) async {
    UserModel user = userProvider.user;
    user.fullName = fullNameController.text;
    user.phoneNumber = phoneNumberController.text;
    user.password = passwordController.text;
    userProvider.setUser(user);
    HiveService.saveUser(user);
    await FirestoreService.storeUser(user).then((_) {
      Log.d(user.toString());
    });
  }
}
