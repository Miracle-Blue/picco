import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/controller_pages.dart';
import 'package:picco/customer/view/pages/home/local_widgets/home_controller.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/user_model.dart';
import 'package:picco/services/auth_service.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

class FloatingActionButtonHomePage extends StatelessWidget {
  final Timer timer;

  const FloatingActionButtonHomePage({Key? key, required this.timer})
      : super(key: key);

  checkUser(UserProvider userProvider, AuthProvider authProvider) async {
    if (userProvider.user.id == null) {
      Log.e("sign in anonymous");
      await AuthService.signInAnonymous().then(
        (value) {
          UserModel user = UserModel(id: value.uid, role: "anonymous");
          userProvider.setUser(user);
          HiveService.saveUser(user);
          FirestoreService.storeUser(user);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final connection = context.watch<ConnectivityResult>();
    final userProvider = context.watch<UserProvider>();
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeController>();

    return AnimatedCrossFade(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      sizeCurve: Curves.easeOutCirc,
      firstCurve: Curves.easeOutExpo,
      secondCurve: Curves.easeOutExpo,
      firstChild: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeProvider.response["typeHouse"]!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(homeProvider.response["typeCity"]!),
                ],
              ),
              const SizedBox(width: 20),
              Image.asset(
                'assets/icons/home_page_icons/home_page_search_icon.png',
                width: 0.06.sw,
              ),
            ],
          ),
        )
            .putElevationOffset(
          radius: 15.0,
          elevation: 5.0,
          x: 0.0,
          y: 0.0,
        )
            .onTap(function: () async {
          HiveService.storeString("city", homeProvider.response["typeCity"]!);
          ConnectivityService.isConnectInternet(connection, context);
          if (connection != ConnectivityResult.none) {
            await checkUser(userProvider, authProvider);
            timer.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PagesController()),
            );
          }
        }),
      ),
      secondChild: const SizedBox.shrink(),
      crossFadeState: homeProvider.response["typeHouse"]!.isNotEmpty &&
              homeProvider.response["typeCity"]!.isNotEmpty
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );
  }
}
