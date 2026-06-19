import 'package:flutter/material.dart';

class CTARow extends StatelessWidget {
  const CTARow({super.key, required this.accentColor});
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Schedule Visit'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: accentColor),
              onPressed: () {},
              child: const Text('Request Details'),
            ),
          ),
        ],
      ),
    );
  }
}
