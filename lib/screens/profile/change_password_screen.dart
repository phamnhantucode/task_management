import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/dialog/alert_dialog.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController repeatPasswordController;

  @override
  void initState() {
    super.initState();
    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    repeatPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.text_edit_profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TMTextField(
              controller: currentPasswordController,
              prefixIcon: const Icon(Icons.password_outlined),
              hintText: context.l10n.text_current_password,
              borderColor: context.appColors.buttonEnable,
            ),
            const SizedBox(
              height: 8,
            ),
            TMTextField(
              controller: newPasswordController,
              prefixIcon: const Icon(Icons.password_outlined),
              hintText: context.l10n.text_new_password,
              borderColor: context.appColors.buttonEnable,
            ),
            const SizedBox(
              height: 8,
            ),
            TMTextField(
              controller: repeatPasswordController,
              prefixIcon: const Icon(Icons.password_outlined),
              hintText: context.l10n.text_repeat_new_password,
              borderColor: context.appColors.buttonEnable,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TMElevatedButton(
                label: context.l10n.text_change,
                borderRadius: 8,
                color: context.appColors.buttonEnable,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: context.appColors.textWhite),
                height: 54,
                onPressed: () async {
                  final user = context.read<AuthenticationCubit>().state.user;
                  if (user != null) {
                    if (currentPasswordController.text ==
                        context.read<AuthenticationCubit>().state.password) {
                      if (newPasswordController.text ==
                          repeatPasswordController.text) {
                        try {
                          await user.updatePassword(newPasswordController.text);
                          showAlertDialog(
                            context: context,
                            title: context.l10n.text_message,
                            content: context.l10n.text_success,
                            rightAction: () {
                              context.pop();
                              //logout when change password success
                              context.read<AuthenticationCubit>().logout();
                            },
                          );
                        } on FirebaseAuthException catch (e) {
                          showAlertDialog(
                            context: context,
                            title: context.l10n.text_message,
                            content: e.message ?? '',
                            rightAction: () {
                              context.pop();
                            },
                          );
                        }
                      }
                    } else {}
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
