import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';

class SellerSearchPage extends StatelessWidget {
  const SellerSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              WidgetUtils.header('Страница поиска'),
              SizedBox(height: 30.h),
              Text(
                'Здесь вы можете собрать свои любимые продукты',
                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
