import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/home/local_widgets/home_controller.dart';
import 'package:picco/models/all_models.dart';

class HeaderImgHomePage extends StatelessWidget {
  final HomeController provider;
  final PageController pageController;

  const HeaderImgHomePage(
      {Key? key, required this.provider, required this.pageController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: PageView(
        controller: pageController,
        children: imagesHeader.map((e) => _box(context, e)).toList(),
      ),
    );
  }

  Image _box(BuildContext context, img) {
    return Image.asset(img, fit: BoxFit.cover);
  }
}
