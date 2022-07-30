import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/view/login/sign_up/sign_up_fullname_page.dart';
import 'package:picco/customer/view/login/sign_up/sign_up_pin_code_page.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';

import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';

import '../../utils.dart';

class SignUpController extends ChangeNotifier {
  bool isLoading = false;
  bool onTap = false;

  final controllerPhoneNumber =
      TextEditingController(text: "+998"); // send code
  final otpController = TextEditingController(); // confirm code

  String verificationId = "";

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendSMS(context, UserProvider providerUser) async {
    onTap = true;
    notifyListeners();
    String? result =
        TextFieldCheckError.errorText(controllerPhoneNumber, true, false);
    if (result != null) {
      return;
    }
    isLoading = true;
    onTap = false;
    notifyListeners();
    await auth.verifyPhoneNumber(
      phoneNumber: controllerPhoneNumber.text,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        Log.d("verificationCompleted");
        isLoading = false;
        notifyListeners();
      },
      //if wrong info
      verificationFailed: (FirebaseAuthException e) async {
        isLoading = false;
        notifyListeners();
        Utils.fireSnackBar(
            normalText: e.message!, redText: "", context: context);
      },
      //resent code
      codeSent: (String verificationId, resendingToken) async {
        Log.d(verificationId);
        isLoading = false;
        this.verificationId = verificationId;
        notifyListeners();
        providerUser.setPhoneNumber(controllerPhoneNumber.text);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpPinCodePage(),
            settings: RouteSettings(arguments: verificationId),
          ),
        );
      },
      //for time out
      codeAutoRetrievalTimeout: (String verificationId) async {
        Log.d("codeAutoRetrievalTimeout");
      },
    );
  }

  commitSMS(context, id, phoneNumber) async {
    var credential = PhoneAuthProvider.credential(
      verificationId: id,
      smsCode: otpController.text,
    );
    isLoading = true;
    notifyListeners();

    await auth.signInWithCredential(credential).then((value) {
      isLoading = false;
      notifyListeners();
      Log.d(value.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpFullNamePage(),
        ),
      );
    }).catchError((e) {
      isLoading = false;
      notifyListeners();
      Log.d(e.message!);
      Utils.fireSnackBar(normalText: e.message!, redText: "", context: context);
    });
  }
}
