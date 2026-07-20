import 'package:flutter/material.dart';

import '../../../../../core/models/property/property_model.dart';
import '../../../../../core/theme/agents_theme.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    super.key,
    required this.agency,
    required this.tierColor,
  });
  final AgencyModel agency;
  final Color tierColor;

  static const _reviews = [
    _ReviewData(
      name: 'Chisom A.',
      initials: 'CA',
      rating: 5,
      date: '2 weeks ago',
      text:
          'Greenfield handled my duplex search professionally. Found a verified 4-bed in Trans-Amadi within 3 days.',
    ),
    _ReviewData(
      name: 'Emeka O.',
      initials: 'EO',
      rating: 5,
      date: '1 month ago',
      text:
          'Very transparent about document status. No hidden charges. Would recommend to colleagues.',
    ),
    _ReviewData(
      name: 'Blessing T.',
      initials: 'BT',
      rating: 4,
      date: '2 months ago',
      text:
          'Responsive and knowledgeable. Slight delay with the NIN check but resolved quickly.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rating = agency.rating ?? 0;

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Text(
                'Reviews',
                style: VeriRentText.titleSmall.copyWith(color: cs.onSurface),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Write a review',
                  style: VeriRentText.labelMedium.copyWith(color: cs.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Rating overview card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(VeriRentRadius.lg),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                // Big number
                Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: VeriRentText.displayMedium.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    _StarRow(rating: rating, size: 14),
                    const SizedBox(height: 2),
                    Text(
                      '${agency.transactions ?? 0} reviews',
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Breakdown bars
                Expanded(
                  child: Column(
                    children: [
                      _RatingBar(
                        stars: 5,
                        fill: 0.80,
                        color: VeriRentColors.gold,
                      ),
                      const SizedBox(height: 5),
                      _RatingBar(
                        stars: 4,
                        fill: 0.14,
                        color: VeriRentColors.gold,
                      ),
                      const SizedBox(height: 5),
                      _RatingBar(
                        stars: 3,
                        fill: 0.04,
                        color: VeriRentColors.warning500,
                      ),
                      const SizedBox(height: 5),
                      _RatingBar(
                        stars: 2,
                        fill: 0.01,
                        color: VeriRentColors.red,
                      ),
                      const SizedBox(height: 5),
                      _RatingBar(
                        stars: 1,
                        fill: 0.01,
                        color: VeriRentColors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Individual review cards
          ..._reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReviewCard(review: r),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.stars,
    required this.fill,
    required this.color,
  });
  final int stars;
  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          width: 14,
          child: Text(
            '$stars',
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ),
        const Icon(Icons.star_rounded, size: 10, color: VeriRentColors.gold),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(VeriRentRadius.full),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 6,
              backgroundColor: cs.outlineVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 28,
          child: Text(
            '${(fill * 100).round()}%',
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewData {
  const _ReviewData({
    required this.name,
    required this.initials,
    required this.rating,
    required this.date,
    required this.text,
  });
  final String name, initials, date, text;
  final int rating;
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final _ReviewData review;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
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
              // Avatar
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: VeriRentColors.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: VeriRentText.labelSmall.copyWith(
                      color: VeriRentColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: VeriRentText.titleSmall.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      review.date,
                      style: VeriRentText.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating.toDouble(), size: 12),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.text,
            style: VeriRentText.bodySmall.copyWith(
              color: cs.onSurface,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, required this.size});
  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (i) {
      final filled = i < rating.floor();
      return Icon(
        filled ? Icons.star_rounded : Icons.star_border_rounded,
        size: size,
        color: VeriRentColors.gold,
      );
    }),
  );
}
