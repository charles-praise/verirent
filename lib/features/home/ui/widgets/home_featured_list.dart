// =============================================================================
//  VeriRent NG — Category Featured Cards
//  Visually communicates property category BEFORE the user reads the title.
//
//  Factory usage:
//    FeaturedCardFactory.build(context, card)
//
//  Variants:
//    Land       → earthy green, plot size hero, document type chip
//    Residential→ warm teal, bed/bath/area chips, neighbourhood focus
//    Commercial → sharp deep-blue, floor/sqm hero, layout + parking chips
//    Estate     → gold premium, unit-count hero, gated security chip
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:verirent/core/shared/network_image/ui/pages/network_image.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../../../core/util/rating_formatter.dart';
import '../../domain/entities/property_model.dart';
import 'home_tier_badge.dart';

// =============================================================================
//  DISPATCHER
// =============================================================================

abstract final class FeaturedCardFactory {
  static Widget build(BuildContext context, PropertyModel card) {
    switch (card.category) {
      case PropertyCategory.land:
        return LandFeaturedCard(card: card);
      case PropertyCategory.commercial:
        return CommercialFeaturedCard(card: card);
      case PropertyCategory.estate:
        return EstateFeaturedCard(card: card);
      case PropertyCategory.residential:
      default:
        return ResidentialFeaturedCard(card: card);
    }
  }
}

// =============================================================================
//  SHARED PRIVATE WIDGETS
// =============================================================================

class _SaveButton extends StatefulWidget {
  const _SaveButton({this.size = 28});
  final double size;
  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton>
    with SingleTickerProviderStateMixin {
  bool _isSaved = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 1.35,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _isSaved = !_isSaved);
    _ctrl.forward(from: 0).then((_) => _ctrl.reverse());
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _toggle,
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isSaved
                  ? VeriRentColors.red.withOpacity(0.65)
                  : Colors.black.withOpacity(0.28),
              shape: BoxShape.circle,
              border: Border.all(
                color: _isSaved
                    ? VeriRentColors.red.withOpacity(0.4)
                    : Colors.white24,
              ),
            ),
            child: Icon(
              _isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: widget.size * 0.5,
              color: _isSaved ? VeriRentColors.red : VeriRentColors.textMuted,
            ),
          ),
        ),
      );
}

Widget _verifiedBadge() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: VeriRentColors.success500,
        borderRadius: BorderRadius.circular(VeriRentRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 9, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            'Verified',
            style: VeriRentText.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, this.accent});
  final IconData icon;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accent ?? cs.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(VeriRentRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 9, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _AgencyRow extends StatelessWidget {
  const _AgencyRow({required this.card, this.accent});
  final PropertyModel card;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accent ?? VeriRentColors.primary;
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 12, color: VeriRentColors.gold),
        const SizedBox(width: 3),
        Text(
          ratingNumberFormater(card.rating ?? 0),
          style: VeriRentText.labelSmall.copyWith(
            color: cs.onSurface,
            fontSize: 10,
          ),
        ),
        Text(
          ' (${ratingNumberFormater(card.reviewCount ?? 0)})',
          style: VeriRentText.bodySmall.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        const Spacer(),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.business_rounded, size: 9, color: color),
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            card.agencyName!,
            style: VeriRentText.labelSmall.copyWith(color: color, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.card, required this.unit, this.accent});
  final PropertyModel card;
  final String unit;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final priceColor = accent ?? cs.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                '₦ ${card.price}',
                style: VeriRentText.titleSmall.copyWith(
                  color: priceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              unit,
              style: VeriRentText.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
          ],
        ),
        TierBadge(
          label: card.tierLabel!
              .replaceAll(' Agency', '')
              .replaceAll(' Individual', ''),
          color: card.tierColor!,
        ),
      ],
    );
  }
}

BorderRadius _topRadius() => BorderRadius.only(
      topLeft: Radius.circular(VeriRentRadius.lg),
      topRight: Radius.circular(VeriRentRadius.lg),
    );

// =============================================================================
//  1. RESIDENTIAL FEATURED CARD  (warm teal, home icon, bed/bath/area)
// =============================================================================

class ResidentialFeaturedCard extends StatelessWidget {
  const ResidentialFeaturedCard({super.key, required this.card});
  final PropertyModel card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: SizedBox(
        height: 280,
        width: 180,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(
              color: card.isVerified!
                  ? VeriRentColors.primary.withOpacity(0.35)
                  : cs.outlineVariant,
              width: card.isVerified! ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CustomNetworkImage(
                      imgUrl: card.imageUrls!.first,
                      borderRadius: _topRadius(),
                    ),
                  ),

                  // Category pill — bottom left
                  // Positioned(
                  //   bottom: 8,
                  //   left: 8,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8,
                  //       vertical: 3,
                  //     ),
                  //     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.55),
                  //       borderRadius: BorderRadius.circular(
                  //         VeriRentRadius.full,
                  //       ),
                  //       border: Border.all(
                  //         color: Colors.white24.withOpacity(0.1),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         const Icon(
                  //           Icons.home_rounded,
                  //           size: 9,
                  //           color: Colors.white70,
                  //         ),
                  //         const SizedBox(width: 3),
                  //         Flexible(
                  //           child: SizedBox(
                  //             width: 40,
                  //             child: Text(
                  //               card.propertyType!,
                  //               style: VeriRentText.labelSmall.copyWith(
                  //                 color: Colors.white,
                  //                 fontSize: 9,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  if (card.isVerified!)
                    Positioned(top: 8, left: 8, child: _verifiedBadge()),

                  Positioned(bottom: 6, right: 6, child: const _SaveButton()),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title!,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              card.location!,
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Chip(
                              icon: Icons.bed_rounded,
                              label: '${card.bedrooms}bd',
                            ),
                            const SizedBox(width: 4),
                            _Chip(
                              icon: Icons.bathtub_outlined,
                              label: '${card.bathrooms}bth',
                            ),
                            const SizedBox(width: 4),
                            _Chip(
                              icon: Icons.square_foot_rounded,
                              label: '${card.areaSqm}m²',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _AgencyRow(card: card),
                      const Spacer(),
                      _PriceRow(card: card, unit: card.priceUnit!),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  2. LAND FEATURED CARD  (earthy green, plot-size hero, document type)
// =============================================================================

class LandFeaturedCard extends StatelessWidget {
  const LandFeaturedCard({super.key, required this.card});
  final PropertyModel card;

  static const _green = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: SizedBox(
        height: 280,
        width: 180,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(
              color: card.isVerified!
                  ? _green.withOpacity(0.45)
                  : cs.outlineVariant,
              width: card.isVerified! ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CustomNetworkImage(
                      imgUrl: card.imageUrls!.first,
                      borderRadius: _topRadius(),
                    ),
                  ),
                  // Bottom gradient
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Plot size hero — bottom left
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${card.areaSqm} m²',
                          style: VeriRentText.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Plot Size',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white60,
                            fontSize: 8,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Land pill — top left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.landscape_rounded,
                            size: 9,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Land',
                            style: VeriRentText.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (card.isVerified!)
                    Positioned(top: 8, right: 8, child: _verifiedBadge()),
                  Positioned(bottom: 6, right: 6, child: const _SaveButton()),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title!,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              card.location!,
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _Chip(
                              icon: Icons.description_rounded,
                              label: card.documentType ?? 'C of O',
                              accent: _green,
                            ),
                            const SizedBox(width: 4),
                            _Chip(
                              icon: Icons.straighten_rounded,
                              label: card.dimensions ?? '—',
                              accent: _green,
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      _AgencyRow(card: card, accent: _green),
                      const Spacer(),
                      _PriceRow(
                        card: card,
                        unit: 'asking price',
                        accent: _green,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  3. COMMERCIAL FEATURED CARD  (deep blue, floor/sqm hero, layout+parking)
// =============================================================================

class CommercialFeaturedCard extends StatelessWidget {
  const CommercialFeaturedCard({super.key, required this.card});
  final PropertyModel card;

  static const _blue = VeriRentColors.info500;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: SizedBox(
        height: 280,
        width: 180,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(
              color:
                  card.isVerified! ? _blue.withOpacity(0.4) : cs.outlineVariant,
              width: card.isVerified! ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CustomNetworkImage(
                      imgUrl: card.imageUrls!.first,
                      borderRadius: _topRadius(),
                    ),
                  ),
                  // Blue gradient
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [_blue.withOpacity(0.7), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  // Commercial pill — top left
                  // Positioned(
                  //   top: 8,
                  //   left: 8,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 8,
                  //       vertical: 3,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: _blue,
                  //       borderRadius: BorderRadius.circular(
                  //         VeriRentRadius.full,
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         const Icon(
                  //           Icons.business_center_rounded,
                  //           size: 9,
                  //           color: Colors.white,
                  //         ),
                  //         const SizedBox(width: 3),
                  //         Text(
                  //           card.propertyType!,
                  //           style: VeriRentText.labelSmall.copyWith(
                  //             color: Colors.white,
                  //             fontSize: 9,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  if (card.isVerified!)
                    Positioned(top: 8, right: 8, child: _verifiedBadge()),
                  // Floor + area overlay
                  Positioned(
                    bottom: 7,
                    left: 8,
                    child: Text(
                      '${card.areaSqm} m²  ·  ${card.floorLevel != null ? '${card.floorLevel}F' : 'GF'}',
                      style: VeriRentText.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(bottom: 6, right: 6, child: const _SaveButton()),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title!,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              card.location!,
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _Chip(
                            icon: Icons.people_alt_rounded,
                            label: card.layoutType ?? 'Open Plan',
                            accent: _blue,
                          ),
                          const SizedBox(width: 4),
                          _Chip(
                            icon: Icons.local_parking_rounded,
                            label: '${card.parkingSpaces ?? 0}P',
                            accent: _blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _AgencyRow(card: card, accent: _blue),
                      const Spacer(),
                      _PriceRow(
                        card: card,
                        unit: card.priceUnit!,
                        accent: _blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
//  4. ESTATE FEATURED CARD  (gold premium, unit-count hero, gated chip)
// =============================================================================

class EstateFeaturedCard extends StatelessWidget {
  const EstateFeaturedCard({super.key, required this.card});
  final PropertyModel card;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => context.push('/listing_details', extra: card),
      child: SizedBox(
        height: 280,
        width: 180,
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(VeriRentRadius.lg),
            border: Border.all(
              color: VeriRentColors.gold.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: VeriRentColors.gold.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: CustomNetworkImage(
                      imgUrl: card.imageUrls!.first,
                      borderRadius: _topRadius(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gold estate badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: VeriRentColors.gold,
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            size: 9,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Estate',
                            style: VeriRentText.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (card.isVerified!)
                    Positioned(top: 8, right: 8, child: _verifiedBadge()),
                  // Unit count
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.domain_rounded,
                          size: 12,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${card.unitCount ?? '—'} Units',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(bottom: 6, right: 6, child: const _SaveButton()),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(VeriRentSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title!,
                        style: VeriRentText.titleSmall.copyWith(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              card.location!,
                              style: VeriRentText.bodySmall.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _Chip(
                            icon: Icons.security_rounded,
                            label: 'Gated',
                            accent: VeriRentColors.gold,
                          ),
                          const SizedBox(width: 4),
                          _Chip(
                            icon: Icons.square_foot_rounded,
                            label: '${card.areaSqm}m²',
                            accent: VeriRentColors.gold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _AgencyRow(card: card, accent: VeriRentColors.gold),
                      const Spacer(),
                      _PriceRow(
                        card: card,
                        unit: 'from',
                        accent: VeriRentColors.gold,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
