import 'package:flutter/material.dart';
import 'package:verirent/core/theme/agents_theme.dart';

class TabToggle extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const TabToggle({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext ctx) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: active ? VeriRentColors.primary : VeriRentColors.surface2,
        border: Border.all(
          color: active ? Colors.transparent : VeriRentColors.border,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: active
            ? [BoxShadow(color: VeriRentColors.primaryGlow, blurRadius: 16)]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: active ? Colors.white : VeriRentColors.textMuted,
          ),
        ),
      ),
    ),
  );
}
