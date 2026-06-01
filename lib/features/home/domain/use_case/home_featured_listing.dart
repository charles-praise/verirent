import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/theme/agents_theme.dart';
import '../../data/local_repo.dart';
import '../../ui/widgets/home_featured_list.dart';

// ── Featured Listing  UseCase ─────────────────────────────────────────────────────────────────

class FeaturedListingsHorizontalUseCase extends StatelessWidget {
  const FeaturedListingsHorizontalUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
        itemCount: kFeatured.length,
        separatorBuilder: (_, _) => const SizedBox(width: VeriRentSpacing.sm),
        itemBuilder: (context, index) {
          return FeaturedCard(card: kFeatured[index]);
        },
      ),
    );
  }
}

// ── Available Listing UseCase ─────────────────────────────────────────────────────────────────

class FeaturedListingsVerticalUseCase extends StatelessWidget {
  const FeaturedListingsVerticalUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: VeriRentSpacing.base),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: VeriRentSpacing.sm,
        crossAxisSpacing: VeriRentSpacing.sm,
        childCount: kFeatured.length,
        itemBuilder: (context, index) {
          return MonsoryFeaturedCard(card: kFeatured[index]);
        },
      ),
    );
  }
}

/*
## If you want mixed sizes

You can vary height by using different image/body lengths, or by adding an explicit height factor per card. Masonry layouts naturally place taller cards without forcing every tile to match the same size [3][1].

Example idea:
- short card: 220 px tall.
- medium card: 260 px tall.
- tall card: 320 px tall.

## One important fix

Do not wrap the masonry grid in `SliverToBoxAdapter`. Put the `SliverMasonryGrid` directly inside `CustomScrollView`, otherwise you can run into the same layout issues you saw before [4][5].

Would you like me to rewrite your `Home` page using a masonry grid for the featured listings?
 */
