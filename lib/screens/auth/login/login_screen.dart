import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/loading_button/loading_button_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/auth/login/component/auth_diaglog_message.dart';
import 'package:room_master_app/screens/auth/login/component/auth_elavated_loading_button.dart';
import 'package:room_master_app/screens/auth/login/provider/validate_provider.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';

import '../../../blocs/authentication/authentication_cubit.dart';
import '../../../navigation/navigation.dart';
import 'component/label_auth_tf.dart';
import 'component/password_field.dart';

final class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final provider = ValidateProvide();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadingButtonCubit(),
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            context.read<AuthenticationCubit>().clean();
          } else if (state.status == LoginStatus.success) {
            var snackBar = const SnackBar(
                content: Text("Successfully!"), backgroundColor: Colors.blue);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.read<AuthenticationCubit>().clean();
          }
          if (state.status == LoginStatus.loading) {
            context.read<LoadingButtonCubit>().setLoading();
          } else {
            context.read<LoadingButtonCubit>().setNormal();
          }
          if (state.authException != null) {
            showAuthDialog(
              context: context,
              title: "Login Failed",
              content: state.authException!.errorMessage(context),
              titleButton: 'CLOSE',
              colorContent: context.appColors.textBlack,
              rightAction: () {
                context.pop();
              },
              colorTitle: context.appColors.failureText,
            );
            context.read<AuthenticationCubit>().clean();
          }
          if (state.isAuthenticated) {
            context.go(NavigationPath.home);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: _boxDecoration(context),
                child: Padding(
                  padding: EdgeInsetsDirectional.all(16.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            alignment: AlignmentDirectional.center,
                            child: Text(context.l10n.task_management,
                                style: context.textTheme.titleLarge?.copyWith(
                                    color: context.appColors.textWhite))),
                        labelTF(context, context.l10n.label_email),
                        _usernameTF(context, provider),
                        labelTF(context, context.l10n.label_password),
                        PasswordField(
                            onTextChange: (content) {
                              context
                                  .read<AuthenticationCubit>()
                                  .setPassword(content);
                            },
                            validator: (value) =>
                                provider.passwordValidator(value)),
                        SizedBox(
                          height: 24.h,
                        ),
                        TMElevatedLoadingButton(
                          height: 50,
                          label: context.l10n.label_login,
                          borderRadius: 50.r,
                          style: context.textTheme.labelLarge
                              ?.copyWith(color: context.appColors.buttonEnable),
                          onPressed: _formKey.currentState!.validate()
                              ? () {
                                  context.read<AuthenticationCubit>().login();
                                }
                              : null,
                          color: context.appColors.textWhite,
                        ),
                        _rememberMe(context),
                        SizedBox(
                          height: 16.h,
                        ),
                        _otherLogin(context),
                        LabelAuth(
                            title: context.l10n.dont_have_acc,
                            labelAuth: context.l10n.label_register,
                            textStyle: context.textTheme.bodyMedium
                                ?.copyWith(color: context.appColors.textWhite),
                            onPress: () {
                              context.go(NavigationPath.register);
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _usernameTF(
  BuildContext context,
  ValidateProvide provider,
) {
  return BlocBuilder<AuthenticationCubit, AuthenticationState>(
    builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            color: context.appColors.tfcolor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TMTextField(
            hintText: context.l10n.label_email,
            textStyle: TextStyle(color: context.appColors.textWhite),
            prefixIcon:
                Icon(Icons.email_outlined, color: context.appColors.textWhite),
            onTextChange: (content) {
              context.read<AuthenticationCubit>().setEmail(content);
            },
            validator: (value) => provider.emailValidator(value),
          ));
    },
  );
}

Widget _rememberMe(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
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
  );
}

Widget _otherLogin(BuildContext context) {
  return Container(
    alignment: AlignmentDirectional.center,
    child: Column(
      children: [
        Text(
          context.l10n.label_other_login,
          style: context.textTheme.bodyMedium
              ?.copyWith(color: context.appColors.textWhite),
        ),
        const SizedBox(
          height: 15,
        ),
        Icon(Icons.fingerprint, size: 90, color: context.appColors.fingerID),
        const SizedBox(
          height: 16,
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
      stops: [0.1, 0.4, 0.7, 0.9],
    ),
  );
}
