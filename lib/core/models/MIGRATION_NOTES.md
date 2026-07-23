# PropertyModel refactor — migration notes

## What changed
- `AgencyModel`, `AsLand`, `AsResidential`, `AsOffice`, `AsLease` no longer
  extend `PropertyModel` / each other. `PropertyModel` now composes them:
  `property.agency`, `property.residential`, `property.land`,
  `property.office`, `property.lease` — each independently nullable.
- `AddressModel` (`address/address_model.dart`) is now shared between
  `PropertyLocation` and `AgencyModel.address` instead of duplicated flat
  fields.
- Flat fields moved into value objects:
  - `price/priceUnit/paymentTerms` → `PropertyPricing` (`property.pricing`)
  - `lga/state/area/address/location/nearbyFacilities` → `PropertyLocation`
    (`property.location`)
  - `emoji/mediaUrls` → `PropertyMedia` (`property.media`)
  - `category/rating/reviewCount/areaSqm/isFeatured/isRecent/showInOptions`
    → `PropertyStatistics` (`property.statistics`)
  - `amenities/features/utilities` → `PropertyFeatures` (`property.features`)
  - `agencyName/tierLabel/tierColor/agentAvatarUrl/agentInitials` → these
    were duplicates of fields already on `AgencyModel`; use
    `property.agency?.name`, `.tierLabel`, etc.

## Call-site updates needed
Anywhere the app currently reads, e.g.:
```dart
property.price
property.agencyName
property.lga
property.mediaUrls
```
becomes:
```dart
property.pricing?.amount
property.agency?.name
property.location?.addressDetails?.lga
property.media?.items
```

## Behavior change worth flagging
`LeaseDetails` no longer implies office/residential fields are present (it
previously inherited them via `AsLease extends AsOffice extends
AsResidential`). Any code that checked `property.asLease.someOfficeField`
needs to instead check `property.office?.someOfficeField` directly, and
any "is this a lease listing" check should become `property.lease != null`
rather than a type check.

## Left as-is, flagged for follow-up
- `AgencyModel.esvarbon` — kept the field name verbatim since its meaning
  isn't clear from context; worth renaming once confirmed with the backend.
- Backend JSON contract: this refactor changes the JSON shape (nested
  objects instead of flat fields), so the FastAPI serializers need to
  emit matching nested payloads, or an adapter layer is needed at the
  network boundary.
