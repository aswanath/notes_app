import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))
    )
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.all(Colors.black),
    )
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
    foregroundColor: Colors.black,
    backgroundColor: Colors.grey[400]
  ),
     switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.black),
          trackColor: MaterialStateProperty.all(Colors.grey),
     ),
     primaryColor: Colors.grey[300],
 scaffoldBackgroundColor: Colors.white,
     iconTheme: const IconThemeData(
          color: Colors.black
     ),
     drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white
     ),
     appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
               color: Colors.black
          ),
       color: Colors.white,
       elevation: 0
     ), textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black)
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black
);

late double deviceWidth;
late double deviceHeight;

DateFormat dateFormat = DateFormat('dd MMM yyyy');
DateFormat dateFormatTime = DateFormat('jm');
DateFormat dateFormatter = DateFormat('yyyy-mm-dd h:mm a');