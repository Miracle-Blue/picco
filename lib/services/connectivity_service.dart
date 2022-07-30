import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:picco/services/utils.dart';

class ConnectivityService {
  static Future<void> isConnectInternet(ConnectivityResult con, context) async {
    if (con == ConnectivityResult.none) {
       await Utils.noInternetConnectionDialog(context);
    }
  }
}
