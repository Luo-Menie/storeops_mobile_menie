import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomFabButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;

  const CustomFabButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FittedBox(
        child: FloatingActionButton(
          mini: true,
          shape: const CircleBorder(),
          elevation: 30,
          splashColor: AppTheme.buttonsColor,
          backgroundColor: AppTheme.primaryColor,
          onPressed: onPressed,
          child: Icon(icon, color: Colors.white, size: 18,),
        ),
      ),
    );
  }
}