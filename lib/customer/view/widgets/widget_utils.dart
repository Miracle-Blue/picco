import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:picco/customer/view/login/sign_up/sign_up_phone_number_page.dart';

import '../login/sign_in/sign_in_page.dart';

class WidgetUtils {
  static Logo Function({required double height, required double width}) logo =
      ({required double height, required double width}) => Logo(
            height: height,
            width: width,
          );
  static Header Function(String) header = (String text) => Header(text: text);
  static SwitchLoginText Function(int) switchLoginText =
      (int index) => SwitchLoginText(index: index);
}

class Logo extends StatelessWidget {
  final double height;
  final double width;

  const Logo({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/picco.png',
      height: height, // 54
      width: width, // 176
    );
  }
}

class Header extends StatelessWidget {
  final String text;

  const Header({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:  TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
    );
  }
}

class SwitchLoginText extends StatelessWidget {
  final int index;

  const SwitchLoginText({Key? key, required this.index}) : super(key: key);

  checkSwitch(BuildContext context) {
    switch (index) {
      case 0:
        return [
          "Уже есть аккаунт? ",
          "Войти",
          const SignInPage(),
        ];
      case 1:
        return [
          "Hет аккаунта? ",
          "Зарегистрироваться",
          const SignUpPhoneNumberPage()
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    checkSwitch(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          checkSwitch(context)[0],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => checkSwitch(context)[2]),
            );
          },
          child: Text(
            checkSwitch(context)[1],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

var maskPhoneNumber = MaskTextInputFormatter(
  mask: '+998 ## ###-##-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
