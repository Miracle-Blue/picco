import 'package:flutter/material.dart';
import 'package:picco/customer/view/login/sign_in/sign_in_page.dart';
import 'package:picco/customer/view/login/sign_up/sign_up_local_widgets/sign_up_phone_pincode.dart';
import 'package:picco/models/all_models.dart';

import 'local_widgets/main_list_tile.dart';

class UnLoggedView extends StatefulWidget {
  const UnLoggedView({Key? key}) : super(key: key);

  @override
  State<UnLoggedView> createState() => _UnLoggedViewState();
}

class _UnLoggedViewState extends State<UnLoggedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "You can Log in your Picco app. \nWe create a new version for our picco app for your comfort",
                  style:
                      TextStyle(height: 2, color: Colors.black, fontSize: 15),
                ),
                const SizedBox(height: 20),
                SignUpButton(
                  function: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                //All settings
                for (int i = 1; i < 4; i++)
                  Column(
                    children: [
                      MainListTile(item: ProfileModel.elements[i]),
                      i == 2
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 25),
                              child: Divider(
                                color: Color.fromRGBO(132, 132, 132, 1),
                              ))
                          : const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
