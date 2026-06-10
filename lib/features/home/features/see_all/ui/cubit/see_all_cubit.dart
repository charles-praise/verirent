import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'see_all_state.dart';

class SeeAllCubit extends Cubit<SeeAllState> {
  SeeAllCubit() : super(SeeAllInitial());
}
