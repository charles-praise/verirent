import 'package:dio/dio.dart';
import 'package:verirent/features/settings/ui/cubit/settings_cubit.dart';

abstract class SettingsRepository {
  Future<SettingsState> fetchSettings();
  Future<void> updateSettings(SettingsState settings);
}

class SettingsRepoImpl implements SettingsRepository {
  final Dio _apiClient;
  SettingsRepoImpl(this._apiClient);

  @override
  Future<SettingsState> fetchSettings() async {
    try {
      final response = await _apiClient.get(
        '/settings',
      ); // todo: add the remote url during implementation
      final data = response.data as Map<String, dynamic>;
      return SettingsState.fromJson(data);
    } catch (e) {
      return const SettingsState();
    }
  }

  @override
  Future<void> updateSettings(SettingsState settings) {
    return _apiClient.put('/settings', data: settings.toJson());
  }
}
