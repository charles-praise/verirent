// =============================================================================
//  6.  TERMS OF SERVICE PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';
import 'privacy.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
            SliverToBoxAdapter(child: SubPageAppBar(title: 'Terms of Service')),
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
                        profileIconBox(Icons.description_outlined, cs.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terms of Service',
                                style: VeriRentText.titleMedium.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'Effective: 1 January 2026',
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
                    ..._termsSections.map(
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

const _termsSections = [
  (
    '1. Acceptance of Terms',
    'By accessing or using VeriRent NG ("the Platform"), you agree to be bound by these Terms of Service and all applicable Nigerian laws and regulations. If you do not agree, please discontinue use immediately.',
  ),
  (
    '2. Platform Purpose',
    'VeriRent NG is a professional certification marketplace for rental property. The platform connects tenants with ESVARBON and NIESV-licensed estate surveyors and valuers in Nigeria.',
  ),
  (
    '3. User Eligibility',
    'You must be at least 18 years of age and a resident or citizen of Nigeria to use the Platform. Professional practitioners must hold valid, current licences from ESVARBON or NIESV.',
  ),
  (
    '4. Verification & Accuracy',
    'All credentials submitted for verification must be genuine. Submitting false documents is a criminal offence under Nigerian law and will result in immediate account termination and referral to relevant authorities.',
  ),
  (
    '5. Fees & Payments',
    'Subscription fees are charged in Nigerian Naira (₦). Payments are processed securely via Paystack. All fees are non-refundable except as required by law.',
  ),
  (
    '6. Prohibited Conduct',
    'You may not use the Platform for fraudulent listings, identity impersonation, harassment of other users, or any activity that violates the Recovery of Premises Law of Rivers State or any applicable Nigerian statute.',
  ),
  (
    '7. Limitation of Liability',
    'Nixel Technology Global is not liable for disputes between landlords and tenants, or for losses arising from reliance on listing information. The Platform provides a verification service, not a tenancy guarantee.',
  ),
  (
    '8. Governing Law',
    'These Terms are governed by the laws of the Federal Republic of Nigeria. Disputes shall be resolved by arbitration in Port Harcourt, Rivers State.',
  ),
];
