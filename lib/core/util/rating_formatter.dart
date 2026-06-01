// =============================================================================
//  VeriRent NG — Rating / Number Formatter
//  Converts a numeric rating or review count into a compact display string.
//
//  Examples:
//    ratingNumberFormater(4.7)       → "4.7"
//    ratingNumberFormater(10.0)      → "10"
//    ratingNumberFormater(1500.0)    → "1.5k"
//    ratingNumberFormater(1000000.0) → "1.0m"
// =============================================================================

/// Formats [number] as a compact, human-readable string.
///
/// Rules (evaluated in descending magnitude order):
///  • ≥ 1,000,000  → "Xm"   (e.g. 2,500,000 → "2.5m")
///  • ≥ 1,000      → "Xk"   (e.g. 1,500     → "1.5k")
///  • whole number → no decimal point
///  • decimal      → one decimal place (standard rating display)
String ratingNumberFormater(double number) {
  // ── Millions ────────────────────────────────────────────────────────────
  if (number >= 1000000) {
    final value = number / 1000000;
    return value == value.truncateToDouble()
        ? '${value.toInt()}m'
        : '${value.toStringAsFixed(1)}m';
  }

  // ── Thousands ────────────────────────────────────────────────────────────
  if (number >= 1000) {
    final value = number / 1000;
    return value == value.truncateToDouble()
        ? '${value.toInt()}k'
        : '${value.toStringAsFixed(1)}k';
  }

  // ── Hundreds / sub-thousand whole numbers ────────────────────────────────
  if (number == number.truncateToDouble()) {
    return number.toInt().toString();
  }

  // ── Decimal rating (e.g. 4.7, 3.5) ─────────────────────────────────────
  return number.toStringAsFixed(1);
}
