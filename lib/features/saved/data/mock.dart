// ── Mock data ──────────────────────────────────────────────────────────────
import '../../../core/api/data/mock_data.dart';
import '../../home/domain/entities/property_model.dart';

/// Saved listings (mirrors what SavedCubit mock returns).
List<PropertyModel> get savedProperties => kSaved;
