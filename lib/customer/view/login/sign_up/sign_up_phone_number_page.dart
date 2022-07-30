import 'package:flutter/material.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/customer/viewmodel/providers/login_controllers/sign_up_phone_pincode_controller.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:provider/provider.dart';

import 'sign_up_local_widgets/sign_up_phone_pincode.dart';

class SignUpPhoneNumberPage extends StatefulWidget {
  const SignUpPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<SignUpPhoneNumberPage> createState() => _SignUpPhoneNumberPageState();
}

class _SignUpPhoneNumberPageState extends State<SignUpPhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpController(),
      builder: (context, _) {
        final provider = context.watch<SignUpController>();
        return Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return SignUpNumberOrPinCode(
              mainText: 'Ваш телефон номер',
              descriptionText: 'Введите свой номер телефона с \n  кодом страны',
              widget: TextField(
                controller: provider.controllerPhoneNumber,
                inputFormatters: [maskPhoneNumber],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TextFieldCheckError.errorBorder(
                        provider.controllerPhoneNumber,
                      ),
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorText: provider.onTap
                      ? TextFieldCheckError.errorText(
                          provider.controllerPhoneNumber,
                          true,
                          false,
                        )
                      : null,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                enabled: provider.isLoading ? false : true,
                onChanged: (value) => setState(() {}),
              ),
              onPress: () => provider.sendSMS(context, userProvider),
            );
          },
        );
      },
    );
  }
}
