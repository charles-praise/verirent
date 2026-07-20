import 'package:verirent/core/models/property/property_model.dart';

class ViewAllChatArgs {
  final List<PropertyModel> properties;
  final String text;
  final PropertyCategory category;

  const ViewAllChatArgs({
    required this.category,
    required this.properties,
    required this.text,
  });
}
