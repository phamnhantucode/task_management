import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';
import 'package:room_master_app/l10n/l10n.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../../navigation/navigation.dart';

class TMElevatedButton extends StatelessWidget {
  const TMElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(context.appColors.textWhite),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r))),
        ),
        child: Text(
          context.l10n.text_login_btn,
          style: context.textTheme.labelLarge
              ?.copyWith(color: context.appColors.buttonEnable),
        ),
        onPressed: () {
          context.read<AuthenticationCubit>().setAuthenticated();
          context.go(NavigationPath.home);
        },
      ),
    );
  }
}
