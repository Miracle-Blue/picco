import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/login/sign_up/sign_up_local_widgets/sign_up_phone_pincode.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/customer/viewmodel/providers/login_controllers/sign_in_controller.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ScrollController scrollController = ScrollController();

  textFieldHintText(int index) {
    switch (index) {
      case 0:
        return 'Телефон номер';
      case 1:
        return 'Пароль';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignInController(),
      builder: (context, _) {
        final provider = context.watch<SignInController>();
        final userProvider = context.read<UserProvider>();
        List<TextEditingController> controllers = <TextEditingController>[
          provider.phoneNumberOrGmailController,
          provider.passwordController,
        ];
        return WillPopScope(
          onWillPop: () async {
            if (provider.scroll) {
              provider.updateScroll(false);
              scrollController.position.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              return false;
            }
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(),
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: provider.scroll
                        ? const ScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 0.12.sh),
                          WidgetUtils.logo(height: 54.h, width: 170.w),
                          SizedBox(height: 0.15.sh),
                          for (int i = 0; i < controllers.length; i++)
                            textFieldBox(i, controllers[i], provider),
                          SizedBox(height: 30.h),
                          SignUpButton(
                            function: () {
                              provider.checkUser(context, userProvider);
                            },
                            provider: provider,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 1.sh,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: const SwitchLoginText(index: 1),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  textFieldBox(
      index, TextEditingController controller, SignInController provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        onTap: () {
          provider.updateScroll(true);
        },
        onSubmitted: (value) {
          provider.updateScroll(false);
          scrollController.position.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        onChanged: (_) => setState(() {}),
        keyboardType: index == 0 ? TextInputType.phone : TextInputType.text,
        inputFormatters: [if (index == 0) maskPhoneNumber],
        // expands: true,
        maxLines: null,
        minLines: null,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          disabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          errorText: provider.isUser == "no" ? "Check your field" : null,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          hintText: textFieldHintText(index),
          hintStyle: const TextStyle(fontSize: 15),
          enabled: provider.isLoading ? false : true,
        ),
      ),
    );
  }
}
