import 'package:flutter/material.dart';

class SetTitleProvider extends ChangeNotifier{
  final titleController = TextEditingController();
  final titleFocus = FocusNode();
  String title = '';

  void getTitle(String _title){
    title = _title;
    notifyListeners();
  }
}