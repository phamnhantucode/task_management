import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/component/top_header/primary.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../component/tm_elevated_button.dart';
import '../component/tm_text_field.dart';
import '../login/component/password_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            decoration: _boxDecoration(context),
            child: Padding(
              padding: EdgeInsetsDirectional.all(16.w),
              child: Padding(
                padding: EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom / 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        alignment: AlignmentDirectional.center,
                        child: Text(context.l10n.task_management,
                            style: context.textTheme.titleLarge
                                ?.copyWith(color: context.appColors.textWhite))),
                    labelTF(context, context.l10n.label_username),
                    _usernameTF(context),
                    labelTF(context, context.l10n.label_email),
                    _emailTF(context),
                    labelTF(context, context.l10n.label_password),
                    const PasswordField(),
                    labelTF(context, context.l10n.label_re_password),
                    const PasswordField(),
                    SizedBox(
                      height: 26.h,
                    ),
                    TMElevatedButton(
                      height: 50,
                      label: context.l10n.label_register,
                      borderRadius: 50.r,
                      style: context.textTheme.labelLarge
                          ?.copyWith(color: context.appColors.buttonEnable),
                      color: context.appColors.textWhite,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    _labelRegister(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _usernameTF(BuildContext context) {
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
        hintText: context.l10n.label_username,
        textStyle: TextStyle(color: context.appColors.textWhite),
        prefixIcon: Icon(Icons.account_circle_outlined,
            color: context.appColors.textWhite),
      ));
}


Widget _emailTF(BuildContext context) {
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
        hintText: context.l10n.label_username,
        textStyle: TextStyle(color: context.appColors.textWhite),
        prefixIcon: Icon(Icons.email_outlined,
            color: context.appColors.textWhite),
      ));
}




Widget _labelRegister(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20),
    padding: const EdgeInsets.all(15),
    alignment: Alignment.bottomCenter,
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          context.l10n.have_acc,
          style: context.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () { context.go(NavigationPath.login); },
          style:  TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          child: Text(
              context.l10n.label_login,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: context.appColors.textWhite)
          ),
        ),
      ],
    ),
  );
}

Widget labelTF(BuildContext context, String label) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      label,
      style: context.textTheme.bodyMedium
          ?.copyWith(color: context.appColors.textWhite),
    ),
  );
}

BoxDecoration _boxDecoration(BuildContext context) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        context.appColors.gradient_bg_1,
        context.appColors.gradient_bg_2,
        context.appColors.gradient_bg_3,
        context.appColors.gradient_bg_4,
      ],
      stops: const [0.1, 0.4, 0.7, 0.9],
    ),
  );
}
