import 'package:flutter/material.dart';

class BackgroundAnimationPageProvider extends ChangeNotifier {
  List<Color> colorList = [
    const Color(0xffE41547),
    const Color(0xff7169F9),
    const Color(0xff4F4E9A),
    const Color(0xffE727DF),
  ];

  List<Alignment> alignmentList = [
    Alignment.bottomLeft,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.topLeft,
  ];

  int index = 0;

  Color bottomColor = Colors.red;
  final Color bottomColor2 = const Color(0xffE727DF);
  Color topColor = const Color(0xff7169F9);
  final Color topColor2 = const Color(0xff4F4E9A);
  Alignment begin = Alignment.bottomLeft;
  Alignment end = Alignment.topRight;

  onEnd() {
    index = index == 5 ? 0 : index + 1;
    bottomColor = colorList[index % colorList.length];
    topColor = colorList[(index + 1) % colorList.length];
    notifyListeners();
  }

  position() {
    begin = begin;
    end = end;
  }

  void changeColor() async {
    bottomColor = Colors.white;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    bottomColor = Colors.red;
    notifyListeners();
  }

  BackgroundAnimationPageProvider() {
    changeColor();
  }
}
