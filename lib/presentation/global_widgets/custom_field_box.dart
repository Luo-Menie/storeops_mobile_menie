import 'package:flutter/material.dart';

class CustomFieldBox extends StatelessWidget {
  final Icon selectedIcon;
  final String hintText;
  final bool obscureText;
  final TextEditingController fieldController;
  

  const CustomFieldBox({super.key, required this.selectedIcon, required this.hintText, required this.obscureText, required this.fieldController});

  @override
  Widget build(BuildContext context) {

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent ),
      borderRadius: BorderRadius.circular(10)
    );

    final inputDecoration= InputDecoration(
        filled: true,
        hint: Text(hintText),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,  
        suffixIcon: selectedIcon,
        contentPadding: EdgeInsets.fromLTRB(10, 12, 0, 0)
      );


    return TextFormField(
                        
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      enableSuggestions: false,
      autocorrect: false,
      decoration: inputDecoration,
      controller: fieldController,
    );
  }
}