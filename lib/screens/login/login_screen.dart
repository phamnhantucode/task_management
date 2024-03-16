import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../../navigation/navigation.dart';

final class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF7BB0EF),
                Color(0xFF66A6F1),
                Color(0xFF478DE0),
                Color(0xFF398AE5),
              ],
              stops: [0.1, 0.4, 0.7, 0.9],
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(16.w),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.l10n.label_username,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: context.appColors.textWhite),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6CA8F1),
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
                      hintText: context.l10n.text_username,
                      textStyle: TextStyle(color: context.appColors.textWhite),
                      prefixIcon: Icon(Icons.account_circle_outlined,
                          color: context.appColors.textWhite),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.l10n.label_password,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: context.appColors.textWhite),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6CA8F1),
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
                        hintText: context.l10n.text_password,
                        textStyle:
                            TextStyle(color: context.appColors.textWhite),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: context.appColors.textWhite,
                        ))),
                SizedBox(
                  height: 24.h,
                ),
                const TMElevatedButton(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: context.appColors.textWhite),
                      child: Checkbox(
                        value: true,
                        checkColor: context.appColors.textBlack,
                        activeColor: context.appColors.textWhite,
                        onChanged: (value) {},
                      ),
                    ),
                    Text(
                      context.l10n.text_remember_me,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: context.appColors.textWhite),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  child: Column(
                    children: [
                      Text(
                        context.l10n.label_other_login,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: context.appColors.textWhite),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Icon(Icons.fingerprint,
                          size: 90, color: context.appColors.fingerID),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.dont_have_acc,
                        style: context.textTheme.bodySmall,
                      ),
                      Text(context.l10n.label_register,
                          style: context.textTheme.bodySmall
                              ?.copyWith(color: context.appColors.textWhite)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
