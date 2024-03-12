import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/domain/repositories/test_repository.dart';
import 'package:room_master_app/theme/app_colors.dart';

import '../blocs/authentication/authentication_cubit.dart';
import '../common/di/service_locator.dart';
import '../l10n/l10n.dart';
import '../navigation/navigation.dart';
import '../theme/theme.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TestRepository>(
          create: (BuildContext context) =>
              ServiceLocator.inject<TestRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationCubit(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

final class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => AppViewState();

  static AppViewState of(BuildContext context) =>
      context.findAncestorStateOfType<AppViewState>()!;
}

final class AppViewState extends State<AppView> {
  ThemeMode _themeMode = ThemeMode.light;
  late AppColors appColors;

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  bool isDarkMode(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark;
  }

  @override
  void initState() {
    if (isDarkMode(context)) {
      appColors = AppColors(appearance: Appearance.dark);
    } else {
      appColors = AppColors(appearance: Appearance.light);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: AppRouter.routerConfig,
        themeMode: _themeMode,
      ),
    );
  }
}