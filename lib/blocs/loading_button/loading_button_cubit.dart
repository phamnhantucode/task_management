import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';


class LoadingButtonCubit extends Cubit<bool> {
  LoadingButtonCubit() : super(
    false
  );
  void setLoading() => emit(true);
  void setNormal() => emit(false);
}
