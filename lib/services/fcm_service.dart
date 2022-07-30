import 'dart:convert';

import 'package:http/http.dart';

class HttpService {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "fcm.googleapis.com";
  static String SERVER_PRODUCTION = "fcm.googleapis.com";

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  static Map<String, String> getHeaders() {
    String _key = 'key=AAAAu_IBR9M:APA91bGtYauFGBhh3Qqt1_myG1Y_Zml__5PqYYhUrGceQA-NfRiN4ydz2R8njNKwQ9rZTjT-2iXMzzkz6VvpCIqhZAm3EVLfjoG_Jzujqsyf13MveDWz8t5t8tO92zj2tQgxBeXSeg6k';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': _key
    };
    return headers;
  }

  // ! requests
  static Future<String?> POST(String api, Map<String, dynamic> body) async {
    var uri = Uri.https(getServer(), api);
    var response = await post(uri, headers: getHeaders(), body: jsonEncode(body));

    if (response.statusCode == 201) {
      return response.body;
    }

    return null;
  }

  // ! APIs
  static String API_FCM_SEND = "/fcm/send";

  // ! body
  static Map<String, dynamic> body({required String name, required String token}) => {
    "notification": {
      "title": name,
      "body": "Your Home is added to sell"
    },
    "registration_ids": [token],
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  };
}