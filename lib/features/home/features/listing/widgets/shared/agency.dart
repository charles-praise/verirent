import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/di/injection.dart';
import 'package:verirent/core/shared/custom_network_media/ui/pages/network_media.dart';
import 'package:verirent/features/router/route_args/chat_args.dart';

import '../../../../../../core/models/property/property_model.dart';
import '../../../../../../core/shared/widgets/action_tile.dart';
import '../../../../../../core/theme/agents_theme.dart';
import '../../../../../profile/ui/pages/view_profile.dart';
import '../../../../../router/route_path/route_paths.dart';

class AgencyBlock extends StatelessWidget {
  const AgencyBlock({super.key, required this.property, required this.accent});
  final PropertyModel property;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final agency = property.agency!;
    final messageCubit = Dependencies.messageCubit;
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewProfile(agency: property.agency!),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(VeriRentRadius.md),
                  ),
                  child: CustomNetworkMedia(
                    url: property.agentAvatarUrl ?? "",
                    borderRadius: BorderRadius.circular(8),
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
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    messageCubit.openChatFromListingPage(
                      property.agency!,
                      property,
                    );
                    if (context.mounted) {
                      context.push(
                        '${RoutePaths.message}/${RoutePaths.chat}',
                        extra: ChatRouteArgs(
                          cubit: messageCubit,
                          property: property,
                        ),
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
                  onPressed: () => showListOfCallTypesBottomSheet(
                    context,
                    listing: property,
                    directPhoneCall: () {}, //todo: implement direct phone call
                    inAppVoiceCall: () {}, //todo: implement voice call
                    inAppVideoCall: () {}, // todo: implement video call
                  ),
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

Future<void> showListOfCallTypesBottomSheet(
  BuildContext context, {
  required PropertyModel listing,
  required VoidCallback directPhoneCall,
  required VoidCallback inAppVoiceCall,
  required VoidCallback inAppVideoCall,
}) {
  final cs = Theme.of(context).colorScheme;

  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
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
            Text('Call Action', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 8),

            Text(
              'Select Call Type.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            ActionTile(
              icon: Icons.phone,
              title: 'Direct Phone Call',
              subtitle: 'Call ${listing.agency!.name} via, Direct phone call',
              onTap: () {
                Navigator.pop(context);
                directPhoneCall();
              },
            ),

            const SizedBox(height: 12),

            ActionTile(
              icon: Icons.wifi_calling_outlined,
              title: 'Voice Call',
              subtitle: 'Call ${listing.agency!.name} via, Voice call',
              onTap: () {
                Navigator.pop(context);
                inAppVoiceCall();
              },
            ),
            const SizedBox(height: 12),

            ActionTile(
              icon: Icons.video_call_outlined,
              title: 'Video Call',
              subtitle: 'Call ${listing.agency!.name} via, Video call',
              onTap: () {
                Navigator.pop(context);
                inAppVideoCall();
              },
            ),
          ],
        ),
      );
    },
  );
}
