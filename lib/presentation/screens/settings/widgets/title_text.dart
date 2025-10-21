import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class TitleText extends StatelessWidget {
  final String textShow;
  final IconData icon;

  const TitleText({
    super.key, required this.textShow, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        Icon(icon, size: 25,color: AppTheme.buttonsColor,),
        Text('$textShow:', 
        style: 
          TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        )
      ]              
    );
  }
}