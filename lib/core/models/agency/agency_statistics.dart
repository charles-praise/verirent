/// An agency's track record — kept separate from identity/contact fields
/// so it can be recomputed by a background job (e.g. after a new review or
/// closed transaction) without touching the rest of the agency profile.
class AgencyStatistics {
  const AgencyStatistics({
    this.rating = 0,
    this.reviewCount = 0,
    this.transactionCount = 0,
  });

  final double rating;
  final int reviewCount;
  final int transactionCount;

  factory AgencyStatistics.fromJson(Map<String, dynamic> json) {
    return AgencyStatistics(
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      transactionCount: (json['transactionCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'reviewCount': reviewCount,
    'transactionCount': transactionCount,
  };
}
