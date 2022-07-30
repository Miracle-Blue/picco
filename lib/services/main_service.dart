import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:picco/customer/view/pages/home/home_page.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/seller/views/seller_page_controller.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'data_service.dart';
import 'hive_service.dart';
import 'log_service.dart';

class MainService {
  static Future<void> init() async {
    Provider.debugCheckInvalidValueType = null;

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    var initAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initIosSetting = const IOSInitializationSettings();
    var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
    await FlutterLocalNotificationsPlugin().initialize(initSetting);


    await Hive.initFlutter();
    await Hive.openBox(HiveService.DB_NAME);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static void initNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Log.d(message.data.toString());
      Utils.showLocalNotification(message, context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Utils.showLocalNotification(message, context);
    });
  }

  static Widget checkUser(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final authProvider = context.watch<AuthProvider>();

    if (userProvider.user.id == null) {
      AuthService.signInAnonymous().then(
        (value) async {
          Log.e("anonymous log");
          UserModel user = UserModel(id: value.uid, role: "anonymous");

          Map<String, String> params = await Utils.deviceParams();

          user.deviceId = params['device_id']!;
          user.deviceType = params['device_type']!;
          user.deviceToken = params['device_token']!;

          userProvider.setUser(user);
          HiveService.saveUser(user);
          FirestoreService.storeUser(user);
        },
      );
    }
    return authProvider.isSeller
        ? const SellerPageController()
        : const HomePage();
  }
}
