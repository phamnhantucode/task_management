import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../../component/tm_text_field.dart';


class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.onTextChange, this.validator, this.controller});

  final void Function(String)? onTextChange;
  final FormFieldValidator? validator;
  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool isHidePassword = true;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.tfcolor,
        borderRadius: BorderRadius.circular(10.0),

      ),
      child: TMTextField(
        obscureText: isHidePassword,
        hintText: context.l10n.label_password,
        keyBoardType: TextInputType.visiblePassword,
        textStyle: TextStyle(color: context.appColors.textWhite),
        onTextChange: widget.onTextChange,
        validator: widget.validator,
        controller: widget.controller,
        prefixIcon: Icon(
          Icons.lock,
          color: context.appColors.textWhite,
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            isHidePassword = !isHidePassword;
          }),
          icon: Icon(
            isHidePassword ? Icons.visibility_off  : Icons.visibility,
            color: context.appColors.textWhite,
          ),
        ),
      ),
    );
  }
}
