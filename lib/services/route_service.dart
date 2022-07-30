import 'package:flutter/material.dart';
import 'package:picco/deep_link_home_page.dart';

class RouteService {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case "/productPage":
        if (args is Map) {
          return MaterialPageRoute(builder: (_) {
            return DeepLinkHomePage(productId: args["houseId"]);
          });
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}


