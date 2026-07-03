import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/models/property_model.dart';
import '../../../../../../core/shared/network_image/ui/pages/network_image.dart';
import '../../../../../../core/theme/agents_theme.dart';
import '../../../../../../core/util/share.dart';
import '../../../../../saved/ui/cubit/saved_cubit.dart';
import '../../../../../saved/ui/cubit/saved_state.dart';
import '../activeListing.dart';
import '../review.dart';
import 'agency.dart';
import 'description.dart';
import 'pricing.dart';
import 'quickInfoBar.dart';
import 'titleBlock.dart';

/// Shared image gallery + CTA scaffold that wraps all detail pages.
class DetailScaffold extends StatefulWidget {
  const DetailScaffold({
    super.key,
    required this.listing,
    required this.accentColor,
    required this.categoryLabel,
    required this.categoryIcon,
    required this.body,
  });
  final PropertyModel listing;
  final Color accentColor;
  final String categoryLabel;
  final IconData categoryIcon;
  final List<Widget> body; // slivers

  @override
  State<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends State<DetailScaffold> {
  int _imgIndex = 0;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final listing = widget.listing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: cs.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: cs.surfaceVariant,
        body: CustomScrollView(
          slivers: [
            // ── App Bar ─────────────────────────────────────────
            SliverAppBar(
              pinned: true,
              backgroundColor: cs.surface,
              foregroundColor: cs.onSurface,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.surfaceVariant,
                    borderRadius: BorderRadius.circular(VeriRentRadius.sm),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: cs.onSurface,
                    size: 18,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: widget.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          VeriRentRadius.full,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.categoryIcon,
                            size: 12,
                            color: widget.accentColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.categoryLabel,
                              maxLines: 1,
                              style: VeriRentText.labelSmall.copyWith(
                                color: widget.accentColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      listing.area ?? "_",
                      style: VeriRentText.labelMedium.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              actions: [
                BlocProvider.value(
                  value: GetIt.I<SavedCubit>(),
                  child: BlocBuilder<SavedCubit, SavedState>(
                    builder: (context, state) {
                      final bool isSaved = state.items.any(
                        (p) => p.id == widget.listing.id,
                      );
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          if (isSaved) {
                            context.read<SavedCubit>().removeSaved(
                              widget.listing.id!,
                            );
                          } else {
                            context.read<SavedCubit>().addSaved(listing);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isSaved
                                ? cs.brightness == Brightness.dark
                                      ? VeriRentColors.red.withOpacity(0.15)
                                      : VeriRentColors.transparent
                                : Colors.transparent,
                          ),
                          child: Icon(
                            isSaved
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isSaved ? VeriRentColors.red : cs.onSurface,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => share(context),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.share_rounded,
                      color: cs.onSurface,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Divider(color: cs.outlineVariant, height: 1),
              ),
            ),

            // ── Image gallery ────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                color: Colors.black,
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageCtrl,
                      onPageChanged: (i) => setState(() => _imgIndex = i),
                      children: listing.imageUrls!
                          .map(
                            (img) => Container(
                              color: Colors.grey[900],
                              child: CustomNetworkImage(imgUrl: img),
                            ),
                          )
                          .toList(),
                    ),
                    // Accent-colored category overlay strip
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(height: 3, color: widget.accentColor),
                    ),
                    // Badges
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          if (listing.isFeatured!)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: VeriRentColors.gold.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(
                                  VeriRentRadius.full,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Featured',
                                      style: VeriRentText.labelSmall.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const Spacer(),
                          // if (listing.isVerified!)
                          //   Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 10,
                          //       vertical: 5,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: VeriRentColors.success500.withOpacity(
                          //         0.9,
                          //       ),
                          //       borderRadius: BorderRadius.circular(
                          //         VeriRentRadius.full,
                          //       ),
                          //     ),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         const Icon(
                          //           Icons.verified_rounded,
                          //           size: 13,
                          //           color: Colors.white,
                          //         ),
                          //         const SizedBox(width: 4),
                          //         Text(
                          //           'Verified',
                          //           style: VeriRentText.labelSmall.copyWith(
                          //             color: Colors.white,
                          //             fontSize: 10,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    // Counter + dots
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(
                            VeriRentRadius.full,
                          ),
                        ),
                        child: Text(
                          '${_imgIndex + 1} / ${listing.imageUrls!.length}',
                          style: VeriRentText.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            listing.imageUrls!.length,
                            (i) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: i == _imgIndex
                                    ? Colors.white
                                    : Colors.white30,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Quick Info Bar ───────────────────────────────────
            SliverToBoxAdapter(
              child: QuickInfoBar(
                listing: listing,
                accentColor: widget.accentColor,
              ),
            ),

            // ── Title + Location ─────────────────────────────────
            SliverToBoxAdapter(child: TitleBlock(listing: listing)),

            // ── CTA ──────────────────────────────────────────────
            // SliverToBoxAdapter(child: _CTARow(accentColor: widget.accentColor)),

            // ── Shared: Agency ───────────────────────────────────
            if (listing.agency != null)
              SliverToBoxAdapter(
                child: AgencyBlock(
                  listing: listing,
                  accent: widget.accentColor,
                ),
              ),
            // ── Pricing ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: PricingBlock(
                listing: listing,
                accent: VeriRentColors.primary,
              ),
            ),
            // ----- Agency active Listing ----------------------
            SliverToBoxAdapter(
              child: ActiveListingsStrip(
                tierColor: listing.tierColor ?? VeriRentColors.primary,
                listing: listing,
              ),
            ),
            // -------- Review Sections -------------------------
            SliverToBoxAdapter(
              child: ReviewsSection(
                agency: listing.agency!,
                tierColor: listing.tierColor ?? VeriRentColors.primary,
              ),
            ),
            // ── Category-specific body ────────────────────────────
            ...widget.body,

            // ── Shared: Description ──────────────────────────────
            SliverToBoxAdapter(child: DescriptionBlock(listing: listing)),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
