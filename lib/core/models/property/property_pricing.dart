enum PriceUnit { perYear, perMonth, perDay, oneTime }

enum PaymentTerms { lumpSum, installments }

/// Everything about what a property costs and how it's paid for.
/// Replaces the flat price/priceUnit/paymentTerms strings — `amount` is
/// now a `double` rather than a `String` so the app can actually sort and
/// filter listings by price range.
class PropertyPricing {
  const PropertyPricing({
    this.amount,
    this.unit,
    this.paymentTerms,
    this.negotiable,
  });

  final double? amount;
  final PriceUnit? unit;
  final PaymentTerms? paymentTerms;
  final bool? negotiable;

  factory PropertyPricing.fromJson(Map<String, dynamic> json) {
    return PropertyPricing(
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] != null ? PriceUnit.values[json['unit'] as int] : null,
      paymentTerms: json['paymentTerms'] != null
          ? PaymentTerms.values[json['paymentTerms'] as int]
          : null,
      negotiable: json['negotiable'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'unit': unit?.index,
    'paymentTerms': paymentTerms?.index,
    'negotiable': negotiable,
  };
}
