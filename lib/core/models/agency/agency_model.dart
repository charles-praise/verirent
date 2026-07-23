import 'package:flutter/material.dart';

import '../address/address_model.dart';
import 'agency_statistics.dart';
import 'verification_tier.dart';

/// An agency is a distinct entity that LISTS properties — it does not
/// extend PropertyModel. The original code had `AgencyModel extends
/// PropertyModel`, which modeled "an agency is a property." A property
/// now just holds a reference to its agency instead (see
/// `PropertyModel.agency`).
class AgencyModel {
  const AgencyModel({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.initials,
    this.tierLabel,
    this.tierColor,
    this.tier,
    this.verified,
    this.union,
    this.address,
    this.statistics = const AgencyStatistics(),
  });

  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? initials;
  final String? tierLabel;
  final Color? tierColor;
  final VerificationTier? tier;
  final bool? verified;
  final String? union;
  final AddressModel? address;
  final AgencyStatistics statistics;

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      initials: json['initials'] as String?,
      tierLabel: json['tierLabel'] as String?,
      tierColor: json['tierColor'] != null
          ? Color(json['tierColor'] as int)
          : null,
      tier: json['tier'] != null
          ? VerificationTier.values[json['tier'] as int]
          : null,
      verified: json['verified'] as bool?,
      union: json['esvarbon'] as String?,
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      statistics: json['statistics'] != null
          ? AgencyStatistics.fromJson(
              json['statistics'] as Map<String, dynamic>,
            )
          : const AgencyStatistics(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
    'initials': initials,
    'tierLabel': tierLabel,
    'tierColor': tierColor?.value,
    'tier': tier?.index,
    'verified': verified,
    'union': union,
    'address': address?.toJson(),
    'statistics': statistics.toJson(),
  };
}
