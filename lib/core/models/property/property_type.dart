/// Shared enums describing what a property IS — its category, structural
/// type, and current listing/verification status. Detail-specific enums
/// (VerificationTier, MediaType, PriceUnit, OverallStatus) live next to the
/// model they describe instead of being dumped in here.

enum PropertyCategory {
  none,
  all,
  featured,
  recent,
  residential,
  estate,
  land,
  commercial,
  shortLet,
  option,
}

enum PropertyType { apartment, duplex, land, house, office }

enum ListingType { rent, sale }

enum UserType { starter, individual }

enum VerificationStatus { verified, pending }

// Renaming new_property -> newProperty is index-safe: JSON stores the
// enum's index, not its name, so ordering (not spelling) is what matters.
enum PropertyCondition { good, newProperty, renovated }
