class Building {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final int cityId;
  final bool isOnFire;
  final int? incidentId;

  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.cityId,
    required this.isOnFire,
    this.incidentId,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      lat: json['latlng']['coordinates'][1],
      lng: json['latlng']['coordinates'][0],
      cityId: json['cityId'],
      isOnFire: json['isOnFire'],
      incidentId: json['isOnFire'] ? json['activeIncident']['id'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'cityId': cityId,
      'isOnFire': isOnFire,
      'incidentId': incidentId,
    };
  }
}
