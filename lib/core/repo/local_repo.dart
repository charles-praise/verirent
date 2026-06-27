import 'package:verirent/features/message/ui/cubit/message_state.dart';

import '../models/property_model.dart';
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
}

class LocalRepoImpl implements LocalRepository {
  @override
  Future<List<PropertyModel>> all() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> allListedProperties = kAllListings;
    return allListedProperties;
  }

  @override
  Future<List<PropertyModel>> commercial() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> commercialProperties = kCommercialListings;
    return commercialProperties;
  }

  @override
  Future<List<PropertyModel>> estate() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> estateProperties = kEstateListings;
    return estateProperties;
  }

  @override
  Future<List<PropertyModel>> featured() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> featuredProperties = kFeatured;
    return featuredProperties;
  }

  @override
  Future<List<PropertyModel>> land() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> landedProperties = kLandListings;
    return landedProperties;
  }

  @override
  Future<List<PropertyModel>> recent() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> recentProperties = kRecent;
    return recentProperties;
  }

  @override
  Future<List<PropertyModel>> residential() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> residentialProperties = kResidentialListings;
    return residentialProperties;
  }

  @override
  Future<List<PropertyModel>> shortLets() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> shortLetProperties = kShortletListings;
    return shortLetProperties;
  }

  @override
  Future<List<PropertyModel>> option() async {
    await Future.delayed(const Duration(seconds: 1));
    List<PropertyModel> allListedProperties = kAllListings;
    return allListedProperties;
  }

  @override
  Future<List<ChatThread>> chatThreads() async {
    await Future.delayed(const Duration(seconds: 1));
    List<ChatThread> chatThreads = kChatThreads;
    return chatThreads;
  }
}
