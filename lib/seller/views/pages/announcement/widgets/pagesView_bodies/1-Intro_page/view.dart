import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/services/log_service.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.d("1-page");
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Станьте хозяином всего за 10 шагов',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            'Присоединитесь. Мы с радостью поможем!',
            style: TextStyle(fontSize: 15.sp),
          ),
        ],
      ),
    );
  }
}
