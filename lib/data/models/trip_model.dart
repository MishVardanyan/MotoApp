class RouteLocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  RouteLocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory RouteLocationModel.fromJson(Map<String, dynamic> json) {
    return RouteLocationModel(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
