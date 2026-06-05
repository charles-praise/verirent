String formatPrice(double value) {
  if (value >= 1000000) {
    return '₦${(value / 1000000).toStringAsFixed(1)}M';
  }
  return '₦${(value / 1000).toStringAsFixed(0)}K';
}
