import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verirent/features/settings/ui/pages/sub_settings.dart';

part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void updateSelectedLanguage(String languageCode) =>
      emit(state.copyWith(selectedLanguage: languageCode));
  void updatePushNotification(bool value) =>
      emit(state.copyWith(pushNotifs: value));
  void updateEmailNotification(bool value) =>
      emit(state.copyWith(emailNotifs: value));
  void updateSmsAlert(bool value) => emit(state.copyWith(smsNotifs: value));
  void updateNewListingAlerts(bool value) =>
      emit(state.copyWith(newListingAlerts: value));
  void updatePriceDropAlert(bool value) =>
      emit(state.copyWith(priceDropAlerts: value));
  void updateTheme(ThemeMode themeMode) =>
      emit(state.copyWith(themeMode: themeMode));
  void updateLocationService(bool value) =>
      emit(state.copyWith(locationEnabled: value));
  void updateShareSearchData(bool value) =>
      emit(state.copyWith(shareSearchData: value));

  @override
  SettingsState? fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SettingsState state) => state.toJson();
}
