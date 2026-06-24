import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:verirent/core/models/property_model.dart';

import 'saved_state.dart';

class SavedCubit extends HydratedCubit<SavedState> {
  SavedCubit() : super(SavedState()) {
    loadSaved();
  }

  final List<PropertyModel> savedProperties = [];

  Future<void> removeAllSaved() async {
    emit(state.copyWith(status: SavedStatus.loading));

    try {
      // Clear your local/mock datasource
      savedProperties.clear();

      emit(
        state.copyWith(items: [], removingIds: {}, status: SavedStatus.empty),
      );
    } catch (e) {
      emit(
        state.copyWith(status: SavedStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> addSaved(PropertyModel item) async {
    final exists = state.items.any((p) => p.id == item.id);

    if (exists) return;

    final updated = [...state.items, item];

    emit(state.copyWith(items: updated, status: SavedStatus.loaded));
  }

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

  @override
  SavedState? fromJson(Map<String, dynamic> json) {
    try {
      final restored = SavedState.fromJson(json);
      // Never restore a loading/initial status — always reload fresh
      if (restored.status == SavedStatus.loading ||
          restored.status == SavedStatus.initial) {
        return restored.copyWith(status: SavedStatus.initial);
      }
      return restored;
    } catch (_) {
      return null; // fall back to default state
    }
  }

  @override
  Map<String, dynamic>? toJson(SavedState state) => state.toJson();
}
