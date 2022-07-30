import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/view/pages/profile/profile_page.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/services/color_service.dart';
import 'package:provider/provider.dart';

import 'pages/home/seller_home_page.dart';
import 'pages/message/seller_message_page.dart';
import 'pages/search/search_page.dart';

class SellerPageController extends StatefulWidget {
  const SellerPageController({Key? key}) : super(key: key);

  @override
  State<SellerPageController> createState() => _SellerPageControllerState();
}

class _SellerPageControllerState extends State<SellerPageController> {
  int pageIndex = 0;

  List<Widget> pages = [
    const SellerHomePage(),
    const SellerSearchPage(),
    const SellerMessagePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var bottomNavBarHeight = MediaQuery.of(context).size.height * 0.09;
    return Scaffold(
      body: Stack(
        children: [
          pages[pageIndex],
        ],
      ),
      bottomNavigationBar: _navBar(context, bottomNavBarHeight),
    );
  }

  Container _navBar(BuildContext context, height) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 1),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icons(icon: CupertinoIcons.home, index: 0),
          icons(icon: CupertinoIcons.search, index: 1),
          Container(
            padding: EdgeInsets.all(height / 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorService.main,
                width: 3,
              ),
            ),
            child: const Icon(CupertinoIcons.repeat),
          ).onTap(function: () {
            final authProvider = context.read<AuthProvider>();
            authProvider.changePageRoute();
          }),
          icons(icon: CupertinoIcons.chat_bubble, index: 2),
          icons(icon: CupertinoIcons.person, index: 3),
        ],
      ),
    );
  }

  icons({icon, index}) {
    return IconButton(
      color: pageIndex == index ? ColorService.main : Colors.black,
      icon: Icon(icon),
      onPressed: () {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }
}
