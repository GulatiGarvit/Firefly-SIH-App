class Node {
  final int id;
  final double lat;
  final double lng;
  final String poi;
  final int buildingId;
  final String? name;

  Node({
    required this.id,
    required this.lat,
    required this.lng,
    required this.poi,
    required this.buildingId,
    this.name,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'],
      lat: json['latlng']['coordinates'][1],
      lng: json['latlng']['coordinates'][0],
      poi: json['poi'],
      buildingId: json['buildingId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'poi': poi,
      'buildingId': buildingId,
      'name': name,
    };
  }
}
