import 'dart:js';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:room_master_app/common/extensions/context.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../../navigation/navigation.dart';

final class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Login', style: context.textTheme.bodyMedium,),
          onPressed: () {
            context.read<AuthenticationCubit>().setAuthenticated();
            context.go(NavigationPath.home);
          },
        ),
      ),
    );
  }
}
