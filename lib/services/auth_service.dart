import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'log_service.dart';
import 'utils.dart';

class AuthService {
  static const isTester = true;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(
      BuildContext context, String name, String? email, String password) async {
    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: email ?? "",
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) await user.updateDisplayName(name);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Log.d('The password provided is too weak.');
        Utils.fireSnackBar(
          normalText: "The password provided is too weak.",
          redText: '',
          context: context,
        );
      } else if (e.code == 'email-already-in-use') {
        Log.d("The account already exists for that email.");
        Utils.fireSnackBar(
          normalText: "The account already exists for that email.",
          redText: '',
          context: context,
        );
      }
    } catch (e) {
      Log.d(e.toString());
      Utils.fireSnackBar(
        normalText: "ERROR $e",
        redText: '',
        context: context,
      );
    }

    return null;
  }

  static Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      Log.d(user.toString());

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Log.d('No user found for email.');
      } else if (e.code == 'wrong-password') {
        Log.d("Wrong password provided for that user.");
      }
    } catch (e) {
      Log.d(e.toString());
    }

    return null;
  }

  static Future<User> signInAnonymous() async {
    UserCredential result = await auth.signInAnonymously();
    Log.d(result.user.toString());
    return result.user!;
  }

  static Future<User?> getUser() async {
    return auth.currentUser;
  }

  static Future<String> getUserUid() async {
    return auth.currentUser?.uid ?? '';
  }

  static void signOutUser(BuildContext context) async {
    await auth.signOut();
  }

  static Future<void> deleteUser(BuildContext context) async {
    Log.i(auth.currentUser.toString());
    // try {
    //   auth.currentUser!.delete();
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'requires-recent-login') {
    //     Utils.fireSnackBar(
    //       normalText:
    //       'The user must re-authenticate before this operation can be executed.',
    //       redText: '',
    //       context: context,
    //     );
    //   }
    // }
  }
}