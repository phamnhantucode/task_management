import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/login/component/register_tf.dart';
import '../component/tm_elevated_button.dart';
import '../login/component/label_auth_tf.dart';
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
                    RegisterTF(hintText: context.l10n.label_username, prefixIcon: Icon(Icons.account_circle_outlined,color: context.appColors.textWhite)),
                    labelTF(context, context.l10n.label_email),
                    RegisterTF(hintText: context.l10n.label_email, prefixIcon: Icon(Icons.email_outlined,color: context.appColors.textWhite)),
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
                    LabelAuth(title: context.l10n.dont_have_acc,label_auth: context.l10n.label_register,textStyle:  context.textTheme.bodyMedium
                        ?.copyWith(color: context.appColors.textWhite),onPress: (){context.go(NavigationPath.login);}),
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
