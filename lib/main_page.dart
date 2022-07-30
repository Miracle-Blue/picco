import 'package:flutter/material.dart';
import 'package:picco/services/deep_link_service.dart';

import 'services/main_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    LinkService.retrieveDynamicLink().then((value) {
      if (value != null) {
        final queryParams = value.queryParameters;
        String? houseId = queryParams['id'];
        Navigator.pushNamed(
          context,
          value.path,
          arguments: {"houseId": houseId},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MainService.initNotification(context);
    return MainService.checkUser(context);
  }
}
