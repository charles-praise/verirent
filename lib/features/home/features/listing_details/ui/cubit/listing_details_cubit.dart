import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'listing_details_state.dart';

class ListingDetailsCubit extends Cubit<ListingDetailsState> {
  ListingDetailsCubit() : super(ListingDetailsInitial());
}
