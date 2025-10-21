import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomLoaderScreen extends StatelessWidget {
  final String message;
  const CustomLoaderScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ 
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.cloud_download_outlined, size: 50,color: AppTheme.buttonsColor,),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.buttonsColor),
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
          ),
          Text(message, style: 
            TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500
            ),
          )
        ]
      ),
    );
  }
}