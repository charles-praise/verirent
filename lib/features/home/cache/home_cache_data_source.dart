import 'dart:convert';

import 'package:hive/hive.dart';

import '../../../core/models/property_model.dart';
import '../domain/home_response.dart';

/// Caches the Home screen's [HomeResponse] as a JSON string in Hive.
///
/// We deliberately don't store typed Hive objects here — PropertyModel's
/// subtype hierarchy (AsResidential/AsLand/AsOffice/AsLease + Color +
/// enums) would need a TypeAdapter per class. Since toJson()/fromJson()
/// already exist and produce plain JSON-safe maps, we just persist that.
class HomeCacheDataSource {
  static const _boxName = 'home_cache';
  static const _dataKey = 'home_response';
  static const _timestampKey = 'home_response_cached_at';

  Box<String>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  Box<String> get _requireBox {
    final box = _box;
    if (box == null) {
      throw StateError('HomeCacheDataSource.init() must be called before use.');
    }
    return box;
  }

  Future<HomeResponse?> read() async {
    final raw = _requireBox.get(_dataKey);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final rawList = (decoded['allProperties'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      final properties = rawList.map(PropertyModel.fromJson).toList();
      return HomeResponse.fromProperties(properties);
    } catch (_) {
      // Cache shape changed (e.g. you added a field) or got corrupted —
      // treat it as a miss rather than crashing the home screen.
      await clear();
      return null;
    }
  }

  Future<void> write(HomeResponse response) async {
    final payload = {
      'allProperties': response.allProperties.map((p) => p.toJson()).toList(),
    };
    await _requireBox.put(_dataKey, jsonEncode(payload));
    await _requireBox.put(_timestampKey, DateTime.now().toIso8601String());
  }

  DateTime? get cachedAt {
    final raw = _requireBox.get(_timestampKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  /// Cache older than this triggers a silent background refresh next
  /// time home() is called, instead of forcing the user to pull-to-refresh.
  bool get isStale {
    final at = cachedAt;
    if (at == null) return true;
    return DateTime.now().difference(at) > const Duration(minutes: 5);
  }

  Future<void> clear() async {
    await _requireBox.delete(_dataKey);
    await _requireBox.delete(_timestampKey);
  }
}
