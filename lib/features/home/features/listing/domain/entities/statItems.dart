import 'package:flutter/cupertino.dart';

class StatItem {
  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
}
