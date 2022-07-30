import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/customer/viewmodel/providers/profile_controllers/user_management_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserManagementPage extends StatelessWidget {
  UserManagementPage({Key? key}) : super(key: key);

  final List labelTexts = [
    'Полное имя',
    'Телефонный номер',
    'Пароль',
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserManagementProvider(),
      builder: (context, _) {
        final provider = context.watch<UserManagementProvider>();
        List<TextEditingController> textControllers = [
          provider.fullNameController,
          provider.phoneNumberController,
          provider.passwordController,
        ];
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              provider.isActive
                  ? Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        return IconButton(
                            onPressed: () async {
                              await provider.onSave(userProvider).then(
                                    (value) => Navigator.pop(context),
                                  );
                            },
                            icon: const Icon(CupertinoIcons.checkmark_alt));
                      },
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 0.05.sw),
                    const Icon(
                      CupertinoIcons.person,
                      size: 25,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'Управление пользователь',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70.h),
                Column(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: ITField(
                              controller: textControllers[i],
                              label: labelTexts[i],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ITField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const ITField({Key? key, required this.controller, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      builder: (context, child) => const _ITField(),
    );
  }
}

class _ITField extends StatelessWidget {
  const _ITField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.read<UserManagementProvider>();
    final userProvider = context.read<UserProvider>();

    final controller =
        context.findAncestorWidgetOfExactType<ITField>()!.controller;
    final label = context.findAncestorWidgetOfExactType<ITField>()!.label;

    String checkTextController(String text) {
      if ("Полное имя" == text) {
        return userProvider.user.fullName!;
      }
      if ("Телефонный номер" == text) {
        return userProvider.user.phoneNumber!;
      }
      if ("Пароль" == text) {
        return userProvider.user.password!;
      }
      return "";
    }

    return TextField(
      obscureText: false,
      controller: controller..text = checkTextController(label),
      inputFormatters: [if ("Телефонный номер" == label) maskPhoneNumber],
      onSubmitted: (_) {
        if (!mainProvider.isActive) mainProvider.onTapTextField();
      },
      keyboardType: "Телефонный номер" == label
          ? TextInputType.phone
          : TextInputType.text,
      decoration: InputDecoration(label: Text(label)),
    );
  }
}
