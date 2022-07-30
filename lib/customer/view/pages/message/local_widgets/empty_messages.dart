import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyMessages extends StatelessWidget {
  const EmptyMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            'Здесь вы можете пообщаться с продавцами или арендаторами жилья.',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
