import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/intro/intro_page.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/main_service.dart';
import 'package:picco/services/route_service.dart';
import 'package:provider/provider.dart';

import 'themes.dart';

Future<void> main() async {
  await MainService.init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    Log.d("Main page");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        StreamProvider(
          create: (context) => Connectivity().onConnectivityChanged,
          initialData: ConnectivityResult.none,
        ),
      ],
      builder: (context, _) {
        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            title: 'Picco',
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? Themes().darkTheme : Themes().lightTheme,
            home: const IntroPage(),
            onGenerateRoute: RouteService.generateRoute,
          ),
        );
      },
    );
  }
}
