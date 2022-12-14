import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes{

  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryClr,
    colorScheme: const ColorScheme.light(
     background: Colors.white
    )
  );

  static final dark = ThemeData(
      brightness: Brightness.dark,
    primaryColor: darkGreyClr,
    colorScheme: const ColorScheme.dark(
      background: Colors.black45
    )
  );

}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
      )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get hintTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600]
      )
  );
}

SnackBar get snackBar{
  return SnackBar(elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
    title: 'Required!!',
    message: 'Title and Note is required!',
    contentType: ContentType.failure,
  ),);

}