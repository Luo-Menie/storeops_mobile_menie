import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomBottomAppbar extends StatelessWidget {
  const CustomBottomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.primaryColor,
      shape:  CircularNotchedRectangle(),
      height: 65.0,
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Image.asset(
            'assets/images/checkpoint_logo_bco2.png',
            width: 120,
            fit: BoxFit.contain,
          )
        ],
      )
    );
  }
}