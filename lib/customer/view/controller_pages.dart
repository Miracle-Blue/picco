import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/view/login/sign_in/sign_in_page.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/providers/login_controllers/google_sign_in_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

import 'pages/favorite/favorite_page.dart';
import 'pages/message/message_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/search/search_page.dart';

class PagesController extends StatefulWidget {
  const PagesController({Key? key}) : super(key: key);

  @override
  State<PagesController> createState() => _PagesControllerState();
}

class _PagesControllerState extends State<PagesController> {
  int pageIndex = 0;

  var activeIconColor = const Color.fromRGBO(84, 74, 235, 1);

  List<Widget> pages = [
    const SearchPage(),
    const FavoritePage(),
    const MessagePage(),
    const ProfilePage(),
  ];

  callToIndex(index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavBarHeight = MediaQuery.of(context).size.height * 0.09;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[pageIndex],
      bottomNavigationBar: _navbar(context, bottomNavBarHeight),
    );
  }

  Container _navbar(BuildContext context, height) {
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
          icons(icon: CupertinoIcons.search, index: 0),
          icons(icon: CupertinoIcons.heart, index: 1),
          SwitchButton(color: activeIconColor, height: height),
          icons(icon: CupertinoIcons.chat_bubble, index: 2),
          icons(icon: CupertinoIcons.person, index: 3),
        ],
      ),
    );
  }

  icons({icon, index}) {
    return IconButton(
      color: pageIndex == index ? activeIconColor : Colors.black,
      icon: Icon(icon),
      onPressed: () {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }
}

class SwitchButton extends StatelessWidget {
  final Color color;
  final double height;

  const SwitchButton({Key? key, required this.color, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      builder: (context, _) => const _SwitchButton(),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    return Container(
      padding: EdgeInsets.all(
          context.findAncestorWidgetOfExactType<SwitchButton>()!.height / 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.findAncestorWidgetOfExactType<SwitchButton>()!.color,
          width: 3,
        ),
      ),
      child: const Icon(CupertinoIcons.repeat),
    ).onTap(function: () {
      Log.d(HiveService.getUser().toString());
      if (userProvider.user.role == "seller") {
        authProvider.changePageRoute();
        Navigator.pop(context);
      } else if (userProvider.user.role == "anonymous") {
        Utils.dialogCommon(
          context,
          "Регистрация",
          "Bы должны зарегистрироваться",
          false,
          () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInPage()));
          },
        );
      } else {
        final googleProvider = context.read<GoogleSignInProvider>();
        googleProvider.googleSignInProvider().then((value) {
          Log.d(value.toString());
          userProvider.setRole("seller");
          userProvider.setEmail(googleProvider.user.email);
          HiveService.saveUser(userProvider.user);
          FirestoreService.storeUser(userProvider.user).then((value) {
            authProvider.changePageRoute();
            Navigator.pop(context);
          }).onError((error, stackTrace) {
            Utils.fireSnackBar(
              normalText: error.toString(),
              redText: "",
              context: context,
            );
          });
        });
      }
    });
  }
}
