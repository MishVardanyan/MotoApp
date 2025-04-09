class MotoModel {
  final String id;
  final String imei;
  final DateTime createdAt;
  final MotoDetails model;
  final DateTime? lastUsedAt;
  final Location? currentLocation;

  MotoModel({
    required this.id,
    required this.imei,
    required this.createdAt,
    required this.model,
    this.lastUsedAt,
    this.currentLocation,
  });

  factory MotoModel.fromJson(Map<String, dynamic> json) {
    return MotoModel(
      id: json['id'] ?? '',
      imei: json['imei'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      model: MotoDetails.fromJson(json['model']),
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'])
          : null,
      currentLocation: json['current_location'] != null
          ? Location.fromJson(json['current_location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'created_at': createdAt.toIso8601String(),
      'model': model.toJson(),
      'last_used_at': lastUsedAt?.toIso8601String(),
      'current_location': currentLocation?.toJson(),
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

  MotoDetails({
    required this.id,
    required this.name,
    required this.maxSpeed,
    required this.engineCapacity,
    required this.imageUrl,
    required this.createdAt,
  });

  factory MotoDetails.fromJson(Map<String, dynamic> json) {
    return MotoDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      maxSpeed: json['max_speed'] ?? 0,
      engineCapacity: json['engine_capacity'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
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
