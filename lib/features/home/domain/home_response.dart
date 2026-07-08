import '../../../core/models/property_model.dart';
import '../../../core/repo/local_repo.dart';

class HomeResponse {
  const HomeResponse({required this.allProperties, required this.categories});

  final List<PropertyModel> allProperties;

  final Map<PropertyCategory, List<PropertyModel>> categories;

  List<PropertyModel> category(PropertyCategory category) {
    return categories[category] ?? [];
  }

  factory HomeResponse.fromProperties(List<PropertyModel> properties) {
    return HomeResponse(
      allProperties: properties,
      categories: categorizeProperties(properties),
    );
  }
}
