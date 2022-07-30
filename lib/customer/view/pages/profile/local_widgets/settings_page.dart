import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'language_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 0.05.sw),
                const Icon(
                  CupertinoIcons.settings,
                  size: 25,
                ),
                const SizedBox(width: 20),
                Text(
                  'Настройки',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            // Column(
            //   children: [
            //     ListTile(
            //       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            //       leading: const Text(
            //         'Темный режим',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       trailing: CupertinoSwitch(
            //         activeColor: Colors.blue,
            //         value: switched,
            //         onChanged: (value) {
            //           setState(
            //             () {
            //               switched = value;
            //             },
            //           );
            //         },
            //       ),
            //     ),
            //     const Divider(color: Colors.black),
            //     ListTile(
            //       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            //       leading: const Text(
            //         'Язык',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       trailing: const Icon(CupertinoIcons.forward),
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 const LanguageSettings(),
            //           ),
            //         );
            //       },
            //     ),
            //     const Divider(color: Colors.black),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
