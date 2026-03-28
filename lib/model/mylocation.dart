class Mylocation {
  final int? id;
  final double? longitudeStart;
  final double? latitudeStart;
  final double? longitudeEnd;
  final double? latitudeEnd;
  final String? addressStart;
  final String? addressEnd;

  Mylocation({
    this.id,
    required this.latitudeStart,
    required this.longitudeStart,
    required this.longitudeEnd,
    required this.latitudeEnd,
    required this.addressStart,
    required this.addressEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'longitudeStart': longitudeStart,
      'latitudeStart': latitudeStart,
      'longitudeEnd': longitudeEnd,
      'latitudeEnd': latitudeEnd,
      'addressStart': addressStart,
      'addressEnd': addressEnd,
    };
  }

  factory Mylocation.fromMap(Map<String, dynamic> map) {
    return Mylocation(
      id: map['id'],
      latitudeStart: map['latitudeStart'],
      longitudeStart: map['longitudeStart'],
      longitudeEnd: map['longitudeEnd'],
      latitudeEnd: map['latitudeEnd'],
      addressStart: map['addressStart'],
      addressEnd: map['addressEnd'],
    );
  }
}
