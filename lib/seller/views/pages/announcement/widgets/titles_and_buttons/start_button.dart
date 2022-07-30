import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/provider.dart';
import 'package:picco/services/color_service.dart';
import 'package:provider/provider.dart';

class StartButton extends StatelessWidget {
  final AnimationController controller;

  const StartButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        context.select((AnnouncementProvider provider) => provider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: MaterialButton(
        height: 45.h,
        minWidth: double.infinity,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0.r)),
        color: ColorService.main,
        onPressed: () {
          if (provider.headers[provider.currentPageIndex].isNotEmpty) {
            controller
              ..repeat(reverse: false)
              ..forward();
          }
          provider.pageController.nextPage(
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        child:   const Text(
          'Старт',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
