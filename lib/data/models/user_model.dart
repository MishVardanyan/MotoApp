class ProfileModel {
  final String id;
  final String? name;
  final String? surname;
  final String email;
  final String? status;
  final String? image;
  final String? backgroundImage;
  final String createdAt;

  ProfileModel({
    required this.id,
    this.name,
    this.surname,
    required this.email,
    this.status,
    this.image,
    this.backgroundImage,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'],
      surname: json['surname'],
      email: json['email'] ?? '',
      status: json['status'],
      image: json['image'],
      backgroundImage: json['background_image'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'status': status,
      'image': image,
      'background_image': backgroundImage,
      'created_at': createdAt,
    };
  }
}
