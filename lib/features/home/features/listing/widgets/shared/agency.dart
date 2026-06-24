import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/models/property_model.dart';
import '../../../../../../core/shared/network_image/ui/pages/network_image.dart';
import '../../../../../../core/theme/agents_theme.dart';
import '../../../../../message/ui/cubit/message_cubit.dart';
import '../../../../../profile/ui/pages/view_profile.dart';

class AgencyBlock extends StatelessWidget {
  const AgencyBlock({super.key, required this.listing, required this.accent});
  final PropertyModel listing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final agency = listing.agency!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(VeriRentRadius.lg),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Listed By',
            style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfile(agency: listing.agency!),
                  ),
                ),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                  ),
                  child: CustomNetworkImage(
                    imgUrl: listing.agentAvatarUrl ?? "",
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agency.name ?? "",
                      maxLines: 2,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: VeriRentColors.gold,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${agency.rating}',
                            style: VeriRentText.labelSmall.copyWith(
                              color: cs.onSurface,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Text(
                          ' · ${agency.transactions} sales',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    GetIt.I<MessagesCubit>().openChatFromListingPage(agency);
                    if (context.mounted) {
                      context.push(
                        '/message/chat',
                        extra: GetIt.I<MessagesCubit>(),
                      );
                    }
                  },
                  icon: const Icon(Icons.message_outlined, size: 16),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: VeriRentColors.transparent,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: VeriRentColors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
