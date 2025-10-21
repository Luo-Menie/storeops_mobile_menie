import 'package:flutter/material.dart';


class CustomSnackbarMessage extends SnackBar {
  CustomSnackbarMessage({
    super.key,
    required String message,
    required Color color,
    required double paddingVertical,
  }) : super(
          content: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          backgroundColor: color,
          elevation: 10,
          padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 10),
          showCloseIcon: false,
          duration: const Duration(seconds: 2),
        );
}

// void snackbarMessage(BuildContext context, String message, Color color, double paddingVertical) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Center(
  //         child: Text(
  //           message,
  //           style: const TextStyle(fontSize: 15),
  //         ),
  //       ),
        
  //       backgroundColor: color,
  //       elevation: 10,
  //       padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 10),
  //       showCloseIcon: false,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }
