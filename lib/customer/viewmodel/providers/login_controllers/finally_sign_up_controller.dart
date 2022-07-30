import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/image_picker_service.dart';

class FinallySignUpController extends ChangeNotifier {
  bool isLoading = false;
  bool scroll = false;
  bool onTap = false;
  bool errorConfirmPassword = false;
  bool errorEmptyFullName = false;
  bool errorEmptyPassword = false;
  bool errorEmptyConfirmPassword = false;
  bool realTimeError = false;
  File? image;
  final picker = ImagePicker();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  textFieldCheck(context, UserProvider provider) async {
    onTap = true;
    notifyListeners();

    if (fullNameController.text.trim().isEmpty) {
      errorEmptyFullName = true;
      notifyListeners();
    }
    if (passwordController.text.trim().isEmpty) {
      errorEmptyPassword = true;
      notifyListeners();
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      errorEmptyConfirmPassword = true;
      notifyListeners();
    }
    if (confirmPasswordController.text.trim() !=
        passwordController.text.trim()) {
      errorConfirmPassword = true;
      notifyListeners();
    }
    if (errorEmptyPassword ||
        errorEmptyFullName ||
        errorConfirmPassword ||
        errorEmptyConfirmPassword) {
      isLoading = false;
      notifyListeners();
      return;
    }

    errorConfirmPassword = false;
    errorEmptyPassword = false;
    errorEmptyFullName = false;
    errorEmptyConfirmPassword = false;
    isLoading = true;
    notifyListeners();

    UserModel userModel = provider.user;
    userModel.fullName = fullNameController.text;
    userModel.password = passwordController.text;
    userModel.role = "user";
    provider.setUser(userModel);
    HiveService.saveUser(userModel);
    await FirestoreService.storeUser(userModel).then((value) {
      isLoading = false;
      notifyListeners();
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<File?> getImage(context) async {
    image = await pickerService.getImage(context);
    notifyListeners();
    return image;
  }

  textFieldOnTap() {
    scroll = true;
    errorConfirmPassword = false;
    notifyListeners();
  }

  updateScroll(value) {
    scroll = value;
    notifyListeners();
  }

  saveUser(){

  }
}
