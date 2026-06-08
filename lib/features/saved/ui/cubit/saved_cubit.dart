import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock.dart';
import 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit() : super(const SavedState());

  // TODO: implement a real api at the call at the `mock.dart` to fetch data from the db, provide a getter for abstraction.
  Future<void> loadSaved() async {
    emit(state.copyWith(status: SavedStatus.loading));
    try {
      final items = savedProperties;
      emit(
        state.copyWith(
          status: items.isEmpty ? SavedStatus.empty : SavedStatus.loaded,
          items: items,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SavedStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> removeSaved(String id) async {
    // Mark as removing for animation
    final removing = {...state.removingIds, id};
    emit(state.copyWith(removingIds: removing));

    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: implement an api call at the `mock.dart` file to delete the saved properties!,provide a getter for abstraction.

    final updated = state.items.where((p) => p.id != id).toList();
    final newRemoving = {...state.removingIds}..remove(id);
    emit(
      state.copyWith(
        items: updated,
        removingIds: newRemoving,
        status: updated.isEmpty ? SavedStatus.empty : SavedStatus.loaded,
      ),
    );
  }

  void setFilter(int index) => emit(state.copyWith(activeFilterIndex: index));
}
