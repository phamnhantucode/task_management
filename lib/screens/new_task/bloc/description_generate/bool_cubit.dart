import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bool_state.dart';

class BoolCubit extends Cubit<bool> {
  BoolCubit() : super(false);

  void toggle() => emit(!state);

  void setTrue() => emit(true);

  void setFalse() => emit(false);

  void setBool(bool value) => emit(value);
}
