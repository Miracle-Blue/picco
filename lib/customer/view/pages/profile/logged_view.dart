import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

import 'local_widgets/profile_main_elements.dart';

class LoggedView extends StatelessWidget {
  const LoggedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 51,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(CupertinoIcons.person, size: 30),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    userProvider.user.fullName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userProvider.user.phoneNumber!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff848484),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      ProfileMainElement(element: ProfileModel.elements[i]),
                      i == 2
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                  color: Color.fromRGBO(132, 132, 132, 1)),
                            )
                          : const SizedBox(height: 10),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  onTap: () async {
                    await Utils.dialogCommon(
                      context,
                      "Выйти",
                      "Вы действительно хотите выйти ?",
                      false,
                      () {
                        HiveService.removeUser();
                        Navigator.pop(context, true);
                      },
                      "Выйти",
                    ).then((value) {
                      if (value == true) {
                        Navigator.pop(context);
                      }
                    });
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(CupertinoIcons.arrow_right,
                        size: 25, color: Colors.black),
                  ),
                  title: Text("Выйти"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
