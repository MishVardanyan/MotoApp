class MotoModel {
  final String id;
  final String vin;
  final DateTime createdAt;
  final MotoDetails model;
  final DateTime? lastUsedAt;
  final Location? currentLocation;
  final String? year; // year դաշտը հենց MotoModel-ում

  MotoModel({
    required this.id,
    required this.vin,
    required this.createdAt,
    required this.model,
    this.lastUsedAt,
    this.currentLocation,
    this.year, // year դաշտը MotoModel-ում
  });

  factory MotoModel.fromJson(Map<String, dynamic> json) {
    return MotoModel(
      id: json['id'] ?? '',
      vin: json['vin'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      model: MotoDetails.fromJson(json['model']),
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'])
          : null,
      currentLocation: json['current_location'] != null
          ? Location.fromJson(json['current_location'])
          : null,
      year: json['year'] ?? null, // year դաշտը ստանում ենք մոդելից դուրս
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'created_at': createdAt.toIso8601String(),
      'model': model.toJson(),
      'last_used_at': lastUsedAt?.toIso8601String(),
      'current_location': currentLocation?.toJson(),
      'year': year, // year դաշտը MotoModel-ում
    };
  }
}

class MotoDetails {
  final String id;
  final String name;
  final int maxSpeed;
  final int engineCapacity;
  final String imageUrl;
  final DateTime createdAt;
  final int? weight;

  MotoDetails({
    required this.id,
    required this.name,
    required this.maxSpeed,
    required this.engineCapacity,
    required this.imageUrl,
    required this.createdAt,
    this.weight,
  });

  factory MotoDetails.fromJson(Map<String, dynamic> json) {
    return MotoDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      maxSpeed: int.parse(json['max_speed'].toString(), radix: 16),
      engineCapacity: int.parse(json['engine_capacity'].toString(), radix: 16),
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      weight: json['weight'] != null
          ? int.parse(json['weight'].toString(), radix: 16)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'max_speed': maxSpeed,
      'engine_capacity': engineCapacity,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'weight': weight,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
