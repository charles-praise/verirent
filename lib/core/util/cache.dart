import 'package:verirent/core/models/property_model.dart';

class Cache {
  final List<PropertyModel> f = [];
  final List<PropertyModel> r = [];
  final List<PropertyModel> c = [];
  final List<PropertyModel> e = [];
  final List<PropertyModel> l = [];
  final List<PropertyModel> re = [];
  final List<PropertyModel> s = [];
  final List<PropertyModel> o = [];

  Future<Map<int, List<PropertyModel>>> cacheListing({
    List<PropertyModel>? featured,
    List<PropertyModel>? residential,
    List<PropertyModel>? commercial,
    List<PropertyModel>? estate,
    List<PropertyModel>? land,
    List<PropertyModel>? recent,
    List<PropertyModel>? shortLet,
    List<PropertyModel>? option,
  }) async {
    return {1: f, 2: r, 3: c, 4: e, 5: l, 6: re, 7: s, 8: o};
  }

  Future<void> destroyCachedListing() async {}
}
