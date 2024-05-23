import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/blocs/authentication/authentication_cubit.dart';
import 'package:room_master_app/common/assets/app_assets.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/domain/repositories/users/users_repository.dart';
import 'package:room_master_app/l10n/l10n.dart';
import 'package:room_master_app/screens/component/tm_elevated_button.dart';
import 'package:room_master_app/screens/component/tm_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.user});

  final User user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  late TextEditingController displayNameTxtController;
  late TextEditingController emailTxtController;

  @override
  void initState() {
    super.initState();
    displayNameTxtController = TextEditingController()..text = widget.user.displayName ?? '';
    emailTxtController = TextEditingController()..text = widget.user.email ?? '';
  }

  @override
  void dispose() {
    displayNameTxtController.dispose();
    emailTxtController.dispose();
    super.dispose();
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
              initialText: widget.user.displayName ?? '',
              controller: displayNameTxtController,
              prefixIcon: Icon(Icons.person_outline),
              hintText: context.l10n.text_email_placeholder,
              borderColor: context.appColors.buttonEnable,
            ),
            const SizedBox(height: 8,),
            TMTextField(
              initialText: widget.user.email ?? '',
              controller: emailTxtController,
              prefixIcon: const Icon(Icons.email_outlined),
              hintText: context.l10n.text_email_placeholder,
              borderColor: context.appColors.buttonEnable,
            ),
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TMElevatedButton(
                label: context.l10n.text_save,
                borderRadius: 8,
                color: context.appColors.buttonEnable,
                style: context.textTheme.bodyMedium?.copyWith(color: context.appColors.textWhite),
                height: 54,
                onPressed: () async {
                  await widget.user.updateDisplayName(displayNameTxtController.text);
                  UsersRepository.instance.updateUserFirstName(context.read<AuthenticationCubit>().state.user?.uid ?? '', displayNameTxtController.text);
                  context.pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
