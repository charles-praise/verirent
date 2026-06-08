import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/property_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  void activeIndex(int index) => emit(state.copyWith(activeIndex: index));

  void filterVisibility(bool isFilterVisible) =>
      emit(state.copyWith(isFilterVisible: isFilterVisible));

  void setProperties(List<PropertyModel> properties) =>
      emit(state.copyWith(allProperties: properties));
}
