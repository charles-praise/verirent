import 'dart:async';

import 'package:verirent/features/home/domain/home_response.dart';
import 'package:verirent/features/message/ui/cubit/message_state.dart';
import 'package:verirent/features/shell/feature/notification/domain/notification_model.dart';

import '../../features/home/cache/home_cache_data_source.dart';
import '../models/property/property_model.dart';
import 'data_source.dart';

abstract class LocalRepository {
  Future<List<PropertyModel>> all();
  Future<List<PropertyModel>> featured();
  Future<List<PropertyModel>> residential();
  Future<List<PropertyModel>> recent();
  Future<List<PropertyModel>> land();
  Future<List<PropertyModel>> commercial();
  Future<List<PropertyModel>> estate();
  Future<List<PropertyModel>> shortLets();
  Future<List<PropertyModel>> option();
  Future<List<ChatThread>> chatThreads();
  Future<List<NotificationModel>> notifications();
  Future<HomeResponse> home();

  /// Emits a fresh [HomeResponse] whenever a background cache refresh
  /// completes after home() already returned cached data. HomeCubit
  /// subscribes to this to silently update the UI without a full reload.
  Stream<HomeResponse> get homeUpdates;

  void dispose();
}

class LocalRepoImpl implements LocalRepository {
  LocalRepoImpl({required HomeCacheDataSource cache}) : _cache = cache;

  final HomeCacheDataSource _cache;
  final _homeUpdatesController = StreamController<HomeResponse>.broadcast();

  @override
  Stream<HomeResponse> get homeUpdates => _homeUpdatesController.stream;

  List<Map<String, dynamic>> _encode(List<PropertyModel> properties) {
    return properties.map((p) => p.toJson()).toList();
  }

  List<PropertyModel> _decode(List<Map<String, dynamic>> raw) {
    return raw.map((json) => PropertyModel.fromJson(json)).toList();
  }

  Future<List<PropertyModel>> _simulateFetch(List<PropertyModel> source) async {
    await Future.delayed(const Duration(seconds: 1));

    final Map<String, dynamic> payload = {'data': _encode(source)};
    final rawList = (payload['data'] as List).cast<Map<String, dynamic>>();
    return _decode(rawList);
  }

  Future<HomeResponse> _fetchHomeFromSource() async {
    final properties = await _simulateFetch(kAllListings);
    return HomeResponse.fromProperties(properties);
  }

  @override
  Future<HomeResponse> home() async {
    final cached = await _cache.read();

    if (cached != null) {
      if (_cache.isStale) {
        // Fire-and-forget: don't make the caller wait on this.
        unawaited(_refreshHomeInBackground());
      }
      return cached;
    }

    final fresh = await _fetchHomeFromSource();
    await _cache.write(fresh);
    return fresh;
  }

  Future<void> _refreshHomeInBackground() async {
    try {
      final fresh = await _fetchHomeFromSource();
      await _cache.write(fresh);
      if (!_homeUpdatesController.isClosed) {
        _homeUpdatesController.add(fresh);
      }
    } catch (_) {
      // Swallow it — the user is already looking at valid cached data.
      // The next call to home() will just retry the background refresh.
    }
  }

  @override
  void dispose() {
    _homeUpdatesController.close();
  }

  @override
  Future<List<PropertyModel>> all() => _simulateFetch(kAllListings);

  @override
  Future<List<PropertyModel>> commercial() =>
      _simulateFetch(kCommercialListings);

  @override
  Future<List<PropertyModel>> estate() => _simulateFetch(kEstateListings);

  @override
  Future<List<PropertyModel>> featured() => _simulateFetch(kFeatured);

  @override
  Future<List<PropertyModel>> land() => _simulateFetch(kLandListings);

  @override
  Future<List<PropertyModel>> recent() => _simulateFetch(kRecent);

  @override
  Future<List<PropertyModel>> residential() =>
      _simulateFetch(kResidentialListings);

  @override
  Future<List<PropertyModel>> shortLets() => _simulateFetch(kShortletListings);

  @override
  Future<List<PropertyModel>> option() => _simulateFetch(kAllListings);

  @override
  Future<List<ChatThread>> chatThreads() async {
    await Future.delayed(const Duration(seconds: 1));
    final raw = kChatThreads.map((t) => t.toJson()).toList();
    return raw.map((json) => ChatThread.fromJson(json)).toList();
  }

  @override
  Future<List<NotificationModel>> notifications() async {
    await Future.delayed(const Duration(seconds: 1));
    List<NotificationModel> notifications = kNotifications
        .map((json) => NotificationModel.fromJson(json: json))
        .toList();
    return notifications;
  }
}

Map<PropertyCategory, List<PropertyModel>> categorizeProperties(
  List<PropertyModel> properties,
) {
  final grouped = <PropertyCategory, List<PropertyModel>>{};

  for (final property in properties) {
    final category = property.category;

    if (category == null) continue;

    grouped.putIfAbsent(category, () => []);
    grouped[category]!.add(property);

    if (property.isFeatured == true) {
      grouped.putIfAbsent(PropertyCategory.featured, () => []);
      grouped[PropertyCategory.featured]!.add(property);
    }

    if (property.isRecent == true) {
      grouped.putIfAbsent(PropertyCategory.recent, () => []);
      grouped[PropertyCategory.recent]!.add(property);
    }

    if (property.showInOptions == true) {
      grouped.putIfAbsent(PropertyCategory.option, () => []);
      grouped[PropertyCategory.option]!.add(property);
    }
  }

  return grouped;
}
