import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomButtonFilter extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed; 

  const CustomButtonFilter({
    super.key,
    required this.icon,
    required this.text,
    required this.active,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextButton.icon(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: active ? Colors.transparent : AppTheme.buttonsColor,
              ),
            ),
          ),
          backgroundColor: active
              ? WidgetStateProperty.all(AppTheme.buttonsColor)
              : WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed, 
        label: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : AppTheme.primaryColor,
            fontSize: 12,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        icon: Icon(icon, size: 18),
      ),
    );
  }
}
