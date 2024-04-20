import 'package:flutter/material.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../../component/tm_text_field.dart';


class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.onTextChange});

  final void Function(String)? onTextChange;

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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TMTextField(
        obscureText: isHidePassword,
        hintText: context.l10n.label_password,
        keyBoardType: TextInputType.visiblePassword,
        textStyle: TextStyle(color: context.appColors.textWhite),
        onTextChange: widget.onTextChange,
        prefixIcon: Icon(
          Icons.lock,
          color: context.appColors.textWhite,
        ),
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            isHidePassword = !isHidePassword;
          }),
          icon: Icon(
            isHidePassword ? Icons.remove_red_eye : Icons.panorama_fish_eye,
            color: context.appColors.textWhite,
          ),
        ),
      ),
    );
  }
}
