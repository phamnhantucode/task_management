import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:room_master_app/domain/repositories/test_repository.dart';
import 'package:room_master_app/screens/bottom_navigation/bloc/bottom_nav_cubit.dart';
import 'package:room_master_app/screens/chat/bloc/user_friends_cubit.dart';
import 'package:room_master_app/theme/app_colors.dart';

import '../blocs/authentication/authentication_cubit.dart';
import '../blocs/setting/setting_cubit.dart';
import '../common/di/service_locator.dart';
import '../domain/repositories/auth/auth_repository.dart';
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
        RepositoryProvider<AuthRepository>(
          create: (BuildContext context) =>
              ServiceLocator.inject<AuthRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationCubit(context.read())..login(isAutoLogin: true),
          ),
          BlocProvider(
            create: (context) => BottomNavCubit(),
          ),
          BlocProvider(
            create: (context) => SettingCubit(),
          ),
          BlocProvider(create: (context) => UserFriendsCubit()..init())
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

final class AppViewState extends State<AppView> with WidgetsBindingObserver {
  ThemeMode themeMode = ThemeMode.light;
  AppColors appColors = AppColors(appearance: Appearance.light);

  void setThemeMode(ThemeMode mode) {
    setState(() {
      themeMode = mode;
      if (themeMode == ThemeMode.dark) {
        appColors = AppColors(appearance: Appearance.dark);
      } else {
        appColors = AppColors(appearance: Appearance.light);
      }
    });
  }

  bool isDarkMode(BuildContext context) {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.bottom]);
    WidgetsBinding.instance.addObserver(this);
    if (themeMode == ThemeMode.system) {
      if (isDarkMode(context)) {
        appColors = AppColors(appearance: Appearance.dark);
        setThemeMode(ThemeMode.dark);
      } else {
        appColors = AppColors(appearance: Appearance.light);
        setThemeMode(ThemeMode.light);
      }
    }
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      if (themeMode == ThemeMode.system) {
        if (isDarkMode(context)) {
          appColors = AppColors(appearance: Appearance.dark);
          setThemeMode(ThemeMode.dark);
        } else {
          appColors = AppColors(appearance: Appearance.light);
          setThemeMode(ThemeMode.light);
        }
      }
    });
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingCubit, SettingState>(
      listener: (context, state) {
        if (state.themeSelected != themeMode) {
          setThemeMode(state.themeSelected);
        }
      },
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRouter.routerConfig,
          themeMode: themeMode,
          locale: Locale(
              context.watch<SettingCubit>().state.languageSelected.getLanguageCode()),
        ),
      ),
    );
  }
}
