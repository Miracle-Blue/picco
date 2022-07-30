import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/customer/viewmodel/providers/login_controllers/sign_up_phone_pincode_controller.dart';
import 'package:picco/services/color_service.dart';
import 'package:provider/provider.dart';

class SignUpNumberOrPinCode extends StatefulWidget {
  final String mainText;
  final String descriptionText;
  final Widget widget;
  final Function() onPress;

  const SignUpNumberOrPinCode({
    Key? key,
    required this.mainText,
    required this.descriptionText,
    required this.widget,
    required this.onPress,
  }) : super(key: key);

  @override
  State<SignUpNumberOrPinCode> createState() => _SignUpNumberOrPinCodeState();
}

class _SignUpNumberOrPinCodeState extends State<SignUpNumberOrPinCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 0.1.sh),
          WidgetUtils.logo(height: 54.h, width: 170.w),
          SizedBox(height: 0.1.sh),
          Text(
            widget.mainText,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          Text(
            widget.descriptionText,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
            child: widget.widget,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: Consumer<SignUpController>(
                builder: (context, provider, child) {
                  return MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 45.h,
                    minWidth: 90.w,
                    disabledElevation: 5,
                    disabledColor: ColorService.main,
                    onPressed: provider.isLoading ? null : widget.onPress,
                    color: ColorService.main,
                    child: provider.isLoading
                        ? Lottie.asset(
                            "assets/lottie/loading_2.json",
                            height: 45.h,
                          )
                        : const Text(
                            'Готово',
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final Function() function;
  dynamic provider;

  SignUpButton({Key? key, required this.function, this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: ColorService.main,
        textColor: Colors.white,
        disabledColor: ColorService.main,
        disabledElevation: 2,
        onPressed: provider != null
            ? provider.isLoading
                ? null
                : function
            : function,
        child: provider != null
            ? provider.isLoading
                ? Lottie.asset("assets/lottie/loading_2.json")
                : const Text('Зарегистрироваться')
            : const Text('Зарегистрироваться'),
      ),
    );
  }
}
