import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/agents_theme.dart';

Future<void> share(BuildContext context) {
  final cs = Theme.of(context).colorScheme;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    showDragHandle: false,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text('Call Action', style: Theme.of(context).textTheme.titleLarge),
            //
            // const SizedBox(height: 8),
            //
            Text(
              'Share Property Via',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShareOption(
                    icon: Icons.link_rounded,
                    label: 'Copy Link',
                    color: cs.primary,
                    onTap: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text: 'https://verirent.ng/ref/CPD2026',
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied!')),
                      );
                    },
                  ),
                  _ShareOption(
                    icon: Icons.message_rounded,
                    label: 'SMS',
                    color: VeriRentColors.success500,
                    onTap: () {},
                  ),
                  _ShareOption(
                    icon: Icons.share_rounded,
                    label: 'WhatsApp',
                    color: const Color(0xFF25D366),
                    onTap: () {},
                  ),
                  _ShareOption(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    color: VeriRentColors.tierVerified,
                    onTap: () {},
                  ),
                  _ShareOption(
                    icon: Icons.more_horiz_rounded,
                    label: 'More',
                    color: cs.onSurfaceVariant,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: VeriRentText.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
