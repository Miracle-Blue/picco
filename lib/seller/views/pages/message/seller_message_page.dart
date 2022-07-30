import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/message/local_widgets/build_messages.dart';
import 'package:picco/customer/view/pages/message/local_widgets/empty_messages.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/models/message_model.dart';

class SellerMessagePage extends StatelessWidget {
  const SellerMessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              WidgetUtils.header("Сообщения"),
              SizedBox(height: 30.h),
              (messages.isEmpty)
                  ? const EmptyMessages()
                  : const BuildMessages(),
            ],
          ),
        ),
      ),
    );
  }
}
