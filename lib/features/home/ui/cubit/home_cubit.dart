import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/models/property_model.dart';
import '../../domain/use_case/listing_use_cases.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState()) {
    loadListing();
  }

  Future<void> loadListing() async {
    try {
      emit(state.copyWith(phase: HomePhase.loading));

      final useCase = GetIt.I<GetPropertiesUseCase>();

      final featured = await useCase(PropertyCategory.featured);
      final residential = await useCase(PropertyCategory.residential);
      final commercial = await useCase(PropertyCategory.commercial);
      final estate = await useCase(PropertyCategory.estate);
      final land = await useCase(PropertyCategory.land);
      final recent = await useCase(PropertyCategory.recent);
      final shortLet = await useCase(PropertyCategory.shortLet);
      final option = await useCase(PropertyCategory.option);

      emit(
        state.copyWith(
          phase: HomePhase.loaded,
          listings: {
            PropertyCategory.featured: featured,
            PropertyCategory.residential: residential,
            PropertyCategory.commercial: commercial,
            PropertyCategory.estate: estate,
            PropertyCategory.land: land,
            PropertyCategory.recent: recent,
            PropertyCategory.shortLet: shortLet,
            PropertyCategory.option: option,
          },
        ),
      );
    } catch (e) {
      emit(state.copyWith(phase: HomePhase.error));
    }
  }

  void activeIndex(int index) => emit(state.copyWith(activeIndex: index));

  void filterVisibility(bool isFilterVisible) =>
      emit(state.copyWith(isFilterVisible: isFilterVisible));
}
