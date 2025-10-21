import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class HeaderItemReport extends StatelessWidget {
  final IconData icon;
  final String textHeader;
  final String valueHeader;
  const HeaderItemReport({super.key, required this.icon, required this.textHeader, required this.valueHeader});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: AppTheme.buttonsColor),
              const SizedBox(width: 4),
              Text(textHeader, style: TextStyle(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w400)),
            ],
          ),
          const SizedBox(height: 5),
          Text(valueHeader, style: TextStyle(fontSize: 13, color: AppTheme.buttonsColor, fontWeight: FontWeight.w700, overflow: TextOverflow.clip)
          , textAlign: TextAlign.center),

          
        ],
      ),
    );
  }
}