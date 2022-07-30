import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';

import 'package:picco/main_page.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

import 'page_route_builder.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  late Timer _timerOne;
  late Timer _timerTwo;
  late Timer _timerThree;

  double _opacity = 0;
  bool _value = true;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _initNotificationToken() async {
    await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    _firebaseMessaging.getToken().then((token) async {
      Log.d(token.toString());
      await HiveService.storeString('fcm_token', token!);
    });
  }

  @override
  void initState() {
    super.initState();
    _initNotificationToken();

    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pushReplacement(
              ThisIsFadeRoute(page: const MainScreen()),
            );
            _timerOne = Timer(
              const Duration(milliseconds: 300),
              () {
                scaleController.reset();
              },
            );
          }
        },
      );

    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 12,
    ).animate(scaleController);

    _timerTwo = Timer(
      const Duration(milliseconds: 600),
      () {
        setState(() {
          _opacity = 1.0;
          _value = false;
        });
      },
    );
    _timerThree = Timer(
      const Duration(milliseconds: 3800),
      () {
        setState(() {
          scaleController.forward();
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scaleController.dispose();
    _timerOne.cancel();
    _timerTwo.cancel();
    _timerThree.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 8),
          opacity: _opacity,
          child: AnimatedContainer(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 2),
            height: _value ? 50 : 150,
            width: _value ? 50 : 150,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(.2),
                  blurRadius: 100,
                  spreadRadius: 10,
                ),
              ],
              color: Colors.deepPurpleAccent,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/logo/logo_picco.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: AnimatedBuilder(
                  animation: scaleAnimation,
                  builder: (c, child) => Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
