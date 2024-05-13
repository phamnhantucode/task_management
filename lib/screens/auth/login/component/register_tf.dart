import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';

import '../../../component/tm_text_field.dart';

class RegisterTF extends StatelessWidget {
  const RegisterTF({super.key, required this.hintText, this.prefixIcon, this.onTextChange, this.validator, this.controller});
  final String? hintText;
  final Widget? prefixIcon;
  final void Function(String content)? onTextChange;
  final FormFieldValidator? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: context.appColors.tfcolor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TMTextField(
          hintText: hintText,
          textStyle: TextStyle(color: context.appColors.textWhite),
          prefixIcon: prefixIcon,
          onTextChange: onTextChange,
          validator: validator,
        ));
  }
}
