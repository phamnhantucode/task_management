import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/common/utils/utils.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/navigation/navigation.dart';
import 'package:room_master_app/screens/auth/login/component/auth_elavated_loading_button.dart';

import '../../../blocs/authentication/authentication_cubit.dart';
import '../../../blocs/loading_button/loading_button_cubit.dart';
import '../login/component/auth_diaglog_message.dart';
import '../login/component/label_auth_tf.dart';
import '../login/component/password_field.dart';
import '../login/component/register_tf.dart';
import '../login/provider/validate_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final provider = ValidateProvide();
  bool _isAgreed = false;

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
              titleButton: 'Close',
              colorContent: context.appColors.textBlack,
              rightAction: () {
                context.pop();
              },
              colorTitle: context.appColors.failureText,
            );
            context.read<AuthenticationCubit>().clean();
          }
          if (state.isAuthenticated) {
            print("Go Home $state");
            context.read<AuthenticationCubit>().clean();
            context.go(NavigationPath.home);
          }
        },
        child: SafeArea(
          child: Scaffold(
            extendBody: true,
            body: Container(
              decoration: _boxDecoration(context),
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 50),
                              alignment: AlignmentDirectional.center,
                              child: Text(context.l10n.task_management,
                                  style: context.textTheme.titleLarge?.copyWith(
                                      color: context.appColors.textWhite))),
                          labelTF(context, context.l10n.label_username),
                          RegisterTF(
                            hintText: context.l10n.label_username,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: context.appColors.textWhite,
                            ),
                            onTextChange: (content) {
                              context
                                  .read<AuthenticationCubit>()
                                  .setUsername(content);
                            },
                              controller: userController,
                              validator: (value) =>
                                  provider.userValidator(value)
                          ),
                          labelTF(context, context.l10n.label_email),
                          RegisterTF(
                              hintText: context.l10n.label_email,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: context.appColors.textWhite,
                              ),
                              onTextChange: (content) {
                                context
                                    .read<AuthenticationCubit>()
                                    .setEmail(content);
                              },
                              controller: emailController,
                              validator: (value) =>
                                  provider.emailValidator(value)),
                          labelTF(context, context.l10n.label_password),
                          PasswordField(
                              controller: passController,
                              onTextChange: (content) {
                                context
                                    .read<AuthenticationCubit>()
                                    .setPassword(content);
                              },
                              validator: (value) =>
                                  provider.passwordValidator(value)),
                          labelTF(context, context.l10n.label_re_password),
                          PasswordField(
                              validator: (value) => provider.confirmPass(
                                  value, passController.text)),
                          SizedBox(
                            height: 20.h,
                          ),
                          CheckboxListTile(
                            title: Text(
                                context.l10n.termandprivacy,
                              style: context.textTheme.bodySmall
                                  ?.copyWith(color: context.appColors.textWhite),
                            ),
                            value: _isAgreed,
                            onChanged: (value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: context.appColors.textWhite,
                            checkColor: context.appColors.buttonEnable,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          TMElevatedLoadingButton(
                            height: 50,
                            label: context.l10n.label_register,
                            borderRadius: 50.r,
                            style: context.textTheme.labelLarge?.copyWith(
                                color: context.appColors.buttonEnable),
                            color: context.appColors.textWhite,
                            onPressed: () {
                              if (_formKey.currentState!.validate() && _isAgreed) {
                                context.read<AuthenticationCubit>().register();
                              } else if (!_isAgreed) {
                              }
                            },
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          LabelAuth(
                              title: context.l10n.have_acc,
                              labelAuth: context.l10n.label_login,
                              textStyle: context.textTheme.bodyMedium?.copyWith(
                                  color: context.appColors.textWhite),
                              onPress: () {
                                context.go(NavigationPath.login);
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
