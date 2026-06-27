// =============================================================================
//  7.  HELP CENTRE PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';
import 'support.dart';

class HelpCentrePage extends StatefulWidget {
  const HelpCentrePage({super.key});

  @override
  State<HelpCentrePage> createState() => _HelpCentrePageState();
}

class _HelpCentrePageState extends State<HelpCentrePage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _expandedIndex;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = _faqItems
        .where(
          (f) =>
              _query.isEmpty ||
              f.q.toLowerCase().contains(_query.toLowerCase()) ||
              f.a.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SubPageAppBar(title: 'Help Centre')),

            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search FAQs...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(child: SectionLabel('Quick Help')),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _QuickHelpChip(
                      icon: Icons.verified_user_outlined,
                      label: 'Verification',
                      onTap: () => setState(() => _query = 'verification'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.home_outlined,
                      label: 'Listings',
                      onTap: () => setState(() => _query = 'listing'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.payment_outlined,
                      label: 'Billing',
                      onTap: () => setState(() => _query = 'payment'),
                    ),
                    const SizedBox(width: 8),
                    _QuickHelpChip(
                      icon: Icons.lock_outlined,
                      label: 'Account',
                      onTap: () => setState(() => _query = 'account'),
                    ),
                  ],
                ),
              ),
            ),

            // FAQs
            SliverToBoxAdapter(
              child: SectionLabel('Frequently Asked Questions'),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(VeriRentRadius.lg),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: filtered.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No results for "$_query"',
                            style: VeriRentText.bodySmall.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(filtered.length, (i) {
                          final isLast = i == filtered.length - 1;
                          return Column(
                            children: [
                              _FaqTile(
                                item: filtered[i],
                                expanded: _expandedIndex == i,
                                onTap: () => setState(() {
                                  _expandedIndex = _expandedIndex == i
                                      ? null
                                      : i;
                                }),
                              ),
                              if (!isLast)
                                Divider(height: 1, color: cs.outlineVariant),
                            ],
                          );
                        }),
                      ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Group(
                  margin: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: profileIconBox(
                        Icons.chat_bubble_outline_rounded,
                        cs.primary,
                      ),
                      title: Text(
                        'Still need help?',
                        style: VeriRentText.bodyMedium.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        'Contact our support team',
                        style: VeriRentText.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactSupportPage(),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
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

class _QuickHelpChip extends StatelessWidget {
  const _QuickHelpChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.md),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: cs.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: VeriRentText.labelSmall.copyWith(
                  color: cs.onSurface,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem(this.q, this.a);
  final String q, a;
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.item,
    required this.expanded,
    required this.onTap,
  });
  final _FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          title: Text(
            item.q,
            style: VeriRentText.bodyMedium.copyWith(color: cs.onSurface),
          ),
          trailing: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: cs.onSurfaceVariant,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              item.a,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.65,
              ),
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 180),
        ),
      ],
    );
  }
}

const _faqItems = [
  _FaqItem(
    'How does verification work on VeriRent NG?',
    'VeriRent NG verifies your identity using NIN and BVN checks, and confirms professional credentials against ESVARBON and NIESV registries. The process is fully automated and typically takes 24–48 hours.',
  ),
  _FaqItem(
    'How do I list a property?',
    'Navigate to the Listings tab, tap the "+" button, and follow the guided process to enter property details, upload photos, set pricing, and submit for review. Listings go live within 2 hours of approval.',
  ),
  _FaqItem(
    'What payment methods are accepted?',
    'We accept all major Nigerian debit cards (Verve, Mastercard, Visa), bank transfers, and USSD payments via Paystack. All transactions are secured with 3DS authentication.',
  ),
  _FaqItem(
    'Can I change or cancel my subscription?',
    'Yes. You can upgrade, downgrade, or cancel your plan at any time from Settings → Subscription Plan. Changes take effect at the start of the next billing cycle.',
  ),
  _FaqItem(
    'How do I reset my password?',
    'Go to Settings → Change Password, or on the login screen tap "Forgot Password". A one-time link will be sent to your registered email address.',
  ),
  _FaqItem(
    'Is my personal data safe?',
    'Yes. All data is encrypted at rest with AES-256 and in transit with TLS 1.3. VeriRent NG is fully NDPR-compliant and undergoes regular third-party security audits.',
  ),
  _FaqItem(
    'How do price drop alerts work?',
    'When a listing matching your saved filters drops in price, you receive an instant push notification. Enable this in Settings → Notifications → Price Drop Alerts.',
  ),
];
