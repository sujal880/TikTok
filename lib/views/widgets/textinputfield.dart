import 'package:flutter/material.dart';

import '../../constants.dart';
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final Icon myIcon;
  final String mylabelText;
  final bool tohide;
  const TextInputField({Key? key,required this.controller,required this.myIcon,required this.mylabelText,required this.tohide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: tohide,
      controller: controller,
      decoration: InputDecoration(
        icon: myIcon,
        labelText: mylabelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: borderColor
          )
        )
      ),
    );
  }
}
