import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/search/detail_widgets/home_map_location.dart';
import 'package:picco/customer/view/widgets/top_divider_bottom_sheet.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/color_service.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/save_image_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_widgets/body_widget.dart';
import 'detail_widgets/header_widget.dart';

class DetailPageInherit extends InheritedNotifier {
  final DetailPageModel detailModel;

  const DetailPageInherit({
    Key? key,
    required this.detailModel,
    required Widget child,
  }) : super(key: key, notifier: detailModel, child: child);

  static DetailPageInherit? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DetailPageInherit>();
  }

  static DetailPageInherit? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<DetailPageInherit>()
        ?.widget;
    return widget is DetailPageInherit ? widget : null;
  }
}

class DetailPageModel extends ChangeNotifier {
  final facilityIcons = [
    'assets/icons/announcement_page_icons/kitchen_facility.png',
    'assets/icons/announcement_page_icons/sofa.png',
    'assets/icons/announcement_page_icons/fridge.png',
    'assets/icons/announcement_page_icons/washing_machine.png',
    'assets/icons/announcement_page_icons/tv.png',
    'assets/icons/announcement_page_icons/wifi.png',
    'assets/icons/announcement_page_icons/air_conditioner.png',
    'assets/icons/announcement_page_icons/dish_washer.png',
    'assets/icons/announcement_page_icons/bath.png',
    'assets/icons/announcement_page_icons/baby.png',
    'assets/icons/announcement_page_icons/animals.png',
  ];

  final facilityNames = [
    'Кухонный мебель',
    'Мебель в комнатах',
    'Холодильник',
    'Стиральная машина',
    'Телевизор',
    'Wi-Fi',
    'Кондитционер',
    'Посудамойка',
    'Душевая кабина',
    'Можно с детми',
    'Можно с животными',
  ];

  final pageController = PageController();
  int currentPage = 0;
  late List<String> homeImages;
  int showConvenienceCount = 4;
  final houses = <HomeModel>[];

  void moveLeft() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
    if (currentPage == 0) {
      pageController.animateToPage(
        homeImages.length - 1,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      );
      currentPage = homeImages.length;
    }
  }

  void moveRight() {
    if (currentPage < homeImages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
    if (currentPage == homeImages.length - 1) {
      pageController.animateToPage(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 400),
      );
      currentPage = 0;
    }
  }

  void changedPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  void likeButton(HomeModel home) {
    // simAds.liked = !simAds.liked;
    notifyListeners();
  }

  void goHomeLocation(BuildContext context, {required Geo geo}) {
    Navigator.pop(context, geo);
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void updateShowConvenienceCount(int facilityCount) {
    showConvenienceCount = facilityCount;
    notifyListeners();
  }

  void sendMessage(BuildContext context, HomeModel homeModel) async {
    final phoneNumber = context.read<UserProvider>().user.phoneNumber;

    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    homeModel.smsCount++;
    await FirestoreService.updateHouse(homeModel);
  }

  void makeCall(BuildContext context, HomeModel homeModel) async {
    final phoneNumber = context.read<UserProvider>().user.phoneNumber;

    final uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }

    homeModel.callsCount++;
    print(homeModel.callsCount);
    await FirestoreService.updateHouse(homeModel);
  }

  void shareLink(String deepLink) async {
    await Share.share(deepLink);
  }

  void loadImage(BuildContext context) async {
    try {
      SaveFile().startDownLoad(context, urls: homeImages);
    } catch (e) {
      throw 'Error has occurred while saving - $e';
    }
  }

  bool haveSimilar(HomeModel homeModel) {
    houses.clear();

    for (var i in homes) {
      int thisPrice = int.parse(homeModel.price);
      int homePrice = int.parse(i.price);
      int count = (thisPrice - homePrice).abs();

      if (count < 50 && count >= 0) {
        houses.add(i);
      }
    }

    return houses.isNotEmpty;
  }

  void openLocationPage(BuildContext context, HomeModel homeModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailMapView(),
        settings: RouteSettings(arguments: homeModel.geo),
      ),
    );
  }

  void showBottomSheet(BuildContext context, String deepLink) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ShareBottomSheet(deepLink: deepLink);
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  final HomeModel homeModel;

  const DetailPage({
    Key? key,
    required this.homeModel,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var detailModel = DetailPageModel();

  @override
  void initState() {
    super.initState();
    detailModel.homeImages = widget.homeModel.houseImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DetailPageInherit(
        detailModel: detailModel,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DetailHeader(deepLink: widget.homeModel.deepLink),
            const DetailBody(),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: Colors.grey,
            height: 2,
            thickness: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _Button(
                  text: 'Cообщение',
                  onPressed: () =>
                      detailModel.sendMessage(context, widget.homeModel),
                ),
                const SizedBox(width: 10),
                _Button(
                  text: 'Позвонить',
                  onPressed: () =>
                      detailModel.makeCall(context, widget.homeModel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const _Button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        minimumSize: Size(160.w, 50.h),
        primary: ColorService.main,
      ),
      onPressed: onPressed,
      child: Text(text),
    ).addExpanded();
  }
}

class _ShareBottomSheet extends StatelessWidget {
  final String deepLink;

  const _ShareBottomSheet({Key? key, required this.deepLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailModel = DetailPageModel();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: topDividerBottomSheet()),
          SizedBox(height: 5.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              Text(
                "Поделиться",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _ShareButton(
            onPressed: () {},
            text: "Телеграм",
            icon:
                "assets/icons/detail_bottom_sheet_icons/telegram-removebg-preview 1.png",
          ),
          _ShareButton(
            onPressed: () {},
            text: "Facebook",
            icon:
                "assets/icons/detail_bottom_sheet_icons/facebook-removebg-preview 1.png",
          ),
          _ShareButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: deepLink));
              Utils.showCopyLinkSnackBar(context);
              Navigator.pop(context);
            },
            text: "Копировать ссылку",
            icon:
                "assets/icons/detail_bottom_sheet_icons/copy-removebg-preview 1.png",
          ),
          _ShareButton(
            onPressed: () => detailModel.loadImage(context),
            text: "Скачать изоброжение",
            icon:
                "assets/icons/detail_bottom_sheet_icons/savr-removebg-preview 1.png",
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final String icon;

  const _ShareButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.h),
      padding: EdgeInsets.only(
        left: 5.w,
        right: 5.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        onTap: onPressed,
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: Image.asset(icon, height: 18.h),
      ),
    );
  }
}
