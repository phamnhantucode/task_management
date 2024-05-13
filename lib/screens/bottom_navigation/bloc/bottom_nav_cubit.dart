import 'package:bloc/bloc.dart';

class BottomNavCubit extends Cubit<NavFunction> {
  BottomNavCubit() : super(NavFunction.home);

  void setNavItemSelected(NavFunction navFunction) {
    emit(navFunction);
  }
}

enum NavFunction {home, calendar, chat, profile}
