/// Shared Nigerian address value object. Previously `state`/`lga`/`area`/
/// `address` were duplicated as flat strings on BOTH `PropertyModel` and
/// `AgencyModel` (via inheritance) — this pulls them into one reusable
/// type composed wherever an address is needed.
class AddressModel {
  const AddressModel({this.address, this.state, this.lga, this.area});

  final String? address;
  final String? state;
  final String? lga;
  final String? area;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] as String?,
      state: json['state'] as String?,
      lga: json['lga'] as String?,
      area: json['area'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'address': address,
    'state': state,
    'lga': lga,
    'area': area,
  };
}
