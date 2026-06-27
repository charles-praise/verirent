// =============================================================================
//  5.  PRIVACY POLICY PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';
import 'share.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SubPageAppBar(
                title: 'Privacy Policy',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShareWithFriendsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        profileIconBox(Icons.policy_outlined, cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'VeriRent NG Privacy Policy',
                                style: VeriRentText.titleMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'Last updated: 1 January 2026',
                                style: VeriRentText.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ..._privacySections.map(
                      (s) => LegalSection(heading: s.$1, body: s.$2),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

class LegalSection extends StatelessWidget {
  const LegalSection({super.key, required this.heading, required this.body});
  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

const _privacySections = [
  (
    '1. Data We Collect',
    'We collect information you provide directly, such as your name, NIN, BVN, professional credentials, and contact details. We also collect usage data, device identifiers, and location data when you enable location services.',
  ),
  (
    '2. How We Use Your Data',
    'Your data is used to verify your identity, match you with relevant rental listings, communicate service updates, and improve the platform. We do not sell your personal data to third parties.',
  ),
  (
    '3. NDPR Compliance',
    'VeriRent NG complies fully with the Nigeria Data Protection Regulation (NDPR) 2019. We process your data lawfully, with your consent, and you have the right to access, rectify, or delete your information at any time.',
  ),
  (
    '4. Data Sharing',
    'We share data with licensed estate agents and surveyors as part of the verification process, and with payment processors for subscription billing. All partners are bound by strict data protection agreements.',
  ),
  (
    '5. Data Retention',
    'We retain your data for as long as your account is active, or as required by Nigerian law. You may request deletion of your account and associated data by contacting support@verirent.ng.',
  ),
  (
    '6. Security',
    'We use AES-256 encryption for data at rest, TLS 1.3 for data in transit, and conduct regular third-party security audits. Access to personal data is restricted to authorised personnel only.',
  ),
  (
    '7. Contact',
    'For privacy-related queries, contact our Data Protection Officer at dpo@verirent.ng or write to Nixel Technology Global, Port Harcourt, Rivers State, Nigeria.',
  ),
];
