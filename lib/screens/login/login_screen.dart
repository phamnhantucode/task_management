import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/authentication/authentication_cubit.dart';
import '../../navigation/navigation.dart';

final class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Login'),
          onPressed: () {
            context.read<AuthenticationCubit>().setAuthenticated();
            context.go(NavigationPath.home);
          },
        ),
      ),
    );
  }
}
