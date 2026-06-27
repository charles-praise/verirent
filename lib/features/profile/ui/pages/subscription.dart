// =============================================================================
//  3.  SUBSCRIPTION PLAN PAGE
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/shared/widgets/profile_and_settings_shared_helper.dart';
import '../../../../core/theme/agents_theme.dart';

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  State<SubscriptionPlanPage> createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  int _selected = 1; // 0=Basic, 1=Pro, 2=Enterprise

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SubPageAppBar(title: 'Subscription Plan'),
            ),

            // Current plan chip
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    profileIconBox(
                      Icons.workspace_premium_rounded,
                      VeriRentColors.gold,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: VeriRentText.bodySmall.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          'Pro Member',
                          style: VeriRentText.titleMedium.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: VeriRentColors.gold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                        border: Border.all(
                          color: VeriRentColors.gold.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        'Renews Jun 2026',
                        style: VeriRentText.labelSmall.copyWith(
                          color: VeriRentColors.gold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SectionLabel('Available Plans')),

            // Plan cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _PlanCard(
                      index: 0,
                      selected: _selected == 0,
                      name: 'Basic',
                      price: 'Free',
                      priceSub: 'Forever',
                      color: VeriRentColors.tierBasic,
                      features: const [
                        'Up to 3 listings',
                        'Standard search visibility',
                        'Basic verification badge',
                        'Email support',
                      ],
                      onTap: () => setState(() => _selected = 0),
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      index: 1,
                      selected: _selected == 1,
                      name: 'Pro',
                      price: '₦9,500',
                      priceSub: 'per month',
                      badge: 'Current',
                      color: VeriRentColors.gold,
                      features: const [
                        'Unlimited listings',
                        'Priority search ranking',
                        'Pro verified badge',
                        'Price drop alerts',
                        'Analytics dashboard',
                        'Priority support',
                      ],
                      onTap: () => setState(() => _selected = 1),
                    ),
                    const SizedBox(height: 10),
                    _PlanCard(
                      index: 2,
                      selected: _selected == 2,
                      name: 'Enterprise',
                      price: '₦45,000',
                      priceSub: 'per month',
                      badge: 'Best Value',
                      color: VeriRentColors.tierEnterprise,
                      features: const [
                        'Everything in Pro',
                        'Multi-agent accounts',
                        'White-label option',
                        'API access',
                        'Dedicated account manager',
                        'SLA guarantee',
                      ],
                      onTap: () => setState(() => _selected = 2),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: ElevatedButton(
                  onPressed: _selected == 1 ? null : () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(
                    _selected == 1
                        ? 'Current Plan'
                        : _selected == 0
                        ? 'Downgrade to Basic'
                        : 'Upgrade to Enterprise',
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    side: BorderSide(color: VeriRentColors.red),
                    foregroundColor: VeriRentColors.red,
                  ),
                  child: Text(
                    'Cancel Subscription',
                    style: VeriRentText.labelLarge.copyWith(
                      color: VeriRentColors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.index,
    required this.selected,
    required this.name,
    required this.price,
    required this.priceSub,
    required this.color,
    required this.features,
    required this.onTap,
    this.badge,
  });
  final int index;
  final bool selected;
  final String name;
  final String price;
  final String priceSub;
  final Color color;
  final List<String> features;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(VeriRentRadius.lg),
          border: Border.all(
            color: selected ? color : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.14),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: VeriRentText.titleMedium.copyWith(color: cs.onSurface),
                ),
                const SizedBox(width: 8),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(VeriRentRadius.full),
                      border: Border.all(color: color.withOpacity(0.4)),
                    ),
                    child: Text(
                      badge!,
                      style: VeriRentText.labelSmall.copyWith(
                        color: color,
                        fontSize: 9,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: VeriRentText.headlineMedium.copyWith(color: color),
                    ),
                    Text(
                      priceSub,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 14, color: color),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
