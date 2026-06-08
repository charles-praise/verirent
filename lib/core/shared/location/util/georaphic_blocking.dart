class GeoRestriction {
  static const allowedCountries = ['Nigeria', 'Ghana', 'Kenya'];

  static bool isAllowedCountry(String? country) {
    if (country == null) return false;

    return allowedCountries.contains(country);
  }
}
