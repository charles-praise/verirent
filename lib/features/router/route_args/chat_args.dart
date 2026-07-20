import '../../../core/models/property/property_model.dart';
import '../../message/ui/cubit/message_cubit.dart';

class ChatRouteArgs {
  final MessagesCubit cubit;
  final PropertyModel property;

  const ChatRouteArgs({required this.cubit, required this.property});
}
