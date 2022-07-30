import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:picco/customer/viewmodel/providers/login_controllers/sign_up_phone_pincode_controller.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'sign_up_local_widgets/sign_up_phone_pincode.dart';

class SignUpPinCodePage extends StatefulWidget {
  const SignUpPinCodePage({Key? key}) : super(key: key);

  @override
  State<SignUpPinCodePage> createState() => _SignUpPinCodePageState();
}

class _SignUpPinCodePageState extends State<SignUpPinCodePage> {
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String; //id

    return ChangeNotifierProvider(
      create: (BuildContext context) => SignUpController(),
      builder: (context, _) {
        final provider = context.watch<SignUpController>();
        return Consumer<UserProvider>(
          builder: (context, providerUser, child) {
            return SignUpNumberOrPinCode(
              mainText: 'Ваш код',
              descriptionText:
                  'Мы отправили SMS с кодом активации \n на ваш телефон' +
                      providerUser.user.phoneNumber!,
              widget: PinCodeTextField(
                controller: provider.otpController,
                length: 6,
                obscureText: false,
                enabled: provider.isLoading ? false : true,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
                },
                appContext: context,
              ),
              onPress: () => provider.commitSMS(
                  context, id, providerUser.user.phoneNumber),
            );
          },
        );
      },
    );
  }
}
