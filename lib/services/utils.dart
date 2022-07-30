import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus_platform_interface/src/enums.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class Utils {
  static fireSnackBar({
    required String normalText,
    required String redText,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade400.withOpacity(0.9),
        content: RichText(
          text: TextSpan(
            text: normalText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: redText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(milliseconds: 2500),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const StadiumBorder(),
      ),
    );
  }

  static String getMonthDayYear(String date) {
    final DateTime now = DateTime.parse(date);
    final String formatted = DateFormat.yMMMMd().format(now);
    return formatted;
  }

  static String currentDate() {
    DateTime now = DateTime.now();

    String convertedDateTime =
        '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}'
        '-'
        '${now.day.toString().padLeft(2, '0')} ${now.hour.toString()}:${now.minute.toString()}';
    return convertedDateTime;
  }

  static Future<bool?> dialogCommon(BuildContext context, String title,
      String message, bool isSingle, onPress,
      [String confirmButtonText = ""]) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (!isSingle)
                TextButton(
                  child: const Text("Отмена"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              TextButton(
                onPressed: onPress,
                child: Text(
                  confirmButtonText.isEmpty
                      ? "Подтверждать"
                      : confirmButtonText,
                ),
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (!isSingle)
                TextButton(
                  child: const Text(
                    "Отмена",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              TextButton(
                onPressed: onPress,
                child: Text(
                  confirmButtonText.isEmpty
                      ? "Подтверждать"
                      : confirmButtonText,
                  style: TextStyle(
                    color: confirmButtonText.isEmpty ? Colors.blue : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  static dialogWithRichTextBody(
    BuildContext context,
    String title,
    String simpleText,
    String richText,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: RichText(
          text: TextSpan(
            text: simpleText,
            style: const TextStyle(color: Colors.black, fontSize: 17),
            children: [
              TextSpan(
                text: richText,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Подтверждать",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> noInternetConnectionDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.2.sw),
                  child: Image.asset("assets/icons/no_internet.png"),
                ),
                const Text(
                  "No Internet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const Text(
                  "Please check your connection status and try again",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final connection = context.read<ConnectivityResult>();
                  Log.d(connection.toString());
                  if (connection != ConnectivityResult.none) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Retry"),
              )
            ],
          );
        } else {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.22.sw),
                  child: Image.asset("assets/icons/no_internet.png"),
                ),
                const SizedBox(height: 10),
                const Text(
                  "No Internet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "Please check your connection status and try again",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final connection = context.read<ConnectivityResult>();
                  Log.d(connection.toString());
                  if (connection != ConnectivityResult.none) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Retry"),
              ),
            ],
          );
        }
      },
    ).then((value) => true);
  }

  static Future<void> simpleDialog({
    required BuildContext context,
    required String title,
    required String body,
    required String leftButtonName,
    required String rightButtonName,
    required void Function() onPressedLeft,
    required void Function() onPressedRight,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              /// Paddings
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.all(30.0),
              insetPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,

              /// Shape
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),

              /// Dialog title
              title: SizedBox(
                width: MediaQuery.of(context).size.width - 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            IconButton(
                              splashRadius: 1,
                              icon: const Icon(
                                CupertinoIcons.clear_thick,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Dialog content => Text Field
              content: SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    body,
                    textAlign: TextAlign.center,
                  )),

              /// Dialog actions => Button
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        height: 36,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: const Color(0xff4f4e9a).withOpacity(0.8),
                        splashColor: Colors.white54,
                        textColor: Colors.white,
                        onPressed: onPressedLeft,
                        child: Text(
                          leftButtonName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      MaterialButton(
                        height: 36,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: const Color(0xff4f4e9a),
                        splashColor: Colors.white54,
                        textColor: Colors.white,
                        onPressed: onPressedRight,
                        child: Text(
                          rightButtonName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static ReadMoreText readMoreText(String definition) {
    return ReadMoreText(
      definition,
      style: TextStyle(color: Colors.black, fontSize: 15.sp),
      moreStyle: TextStyle(color: Colors.blue, fontSize: 14.sp),
      trimLines: 2,
      colorClickableText: Colors.blue,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Читать далее',
      trimExpandedText: ' Показать меньше',
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showCopyLinkSnackBar(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Flexible(
                child: Lottie.asset(
                  "assets/lottie/copy_link.json",
                  height: 0.8.sh,
                  repeat: false,
                ),
              ),
              const Text("Скопировано"),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  static Future<Map<String, String>> deviceParams() async {
    Map<String, String> params = {};
    var deviceInfo = DeviceInfoPlugin();
    String token = HiveService.loadString('fcm_token');
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      params.addAll({
        'device_id': iosDeviceInfo.identifierForVendor!,
        'device_type': "I",
        'device_token': token
      });
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      params.addAll({
        'device_id': androidDeviceInfo.androidId ?? "",
        'device_type': "${androidDeviceInfo.brand} ${androidDeviceInfo.model}",
        'device_token': token
      });
    }

    return params;
  }

  static Future<void> showLocalNotification(
    RemoteMessage message,
    BuildContext context,
  ) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    var android = const AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "channelDescription",
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);

    int id = Random().nextInt((pow(2, 31) - 1).toInt());
    await FlutterLocalNotificationsPlugin().show(id, title, body, platform);
  }
}
