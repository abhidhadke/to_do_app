import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF1F1B24);
const Color darkHeaderClr = Color(0xFF424242);
const Color dropDownClr = Color(0xFFA1E1FA);

class Themes{

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryClr,
    colorScheme: const ColorScheme.light(
     background: Color(0xffF0D5FF),
      tertiary: Color(0xffE3E4FA)
    )
  );

  static final dark = ThemeData(
    useMaterial3: true,
    primaryColor: darkGreyClr,
    colorScheme: const ColorScheme.dark(
      background: Color(0xff343434),
      tertiary: Color(0xff36454F)
    )
  );

}

TextStyle get subHeadingStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
      )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Get.isDarkMode ? Colors.white : Colors.black
      )
  );
}

TextStyle get hintTitleStyle {
  return GoogleFonts.poppins(
      textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600]
      )
  );
}

SnackBar get snackBarRequired{
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
    title: 'Required!!',
    message: 'Title and Note is required!',
    contentType: ContentType.failure,
  ),);

}

SnackBar get taskAddedBar{
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Success!!',
      message: 'Task added successfully!',
      contentType: ContentType.success,
    ),);

}

SnackBar get taskDeletedBar{
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Deleted!!',
      message: 'Task deleted successfully!',
      contentType: ContentType.success,
    ),);

}

SnackBar get todayCompleted{
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Hooray!!',
      message: 'Task completed for today...Good job!!',
      contentType: ContentType.success,
    ),);

}