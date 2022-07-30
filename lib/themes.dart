import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    backgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
  );
  final darkTheme = ThemeData.dark().copyWith(
    textTheme: GoogleFonts.notoSansJavaneseTextTheme(),
  );
}
