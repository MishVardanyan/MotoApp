class NewsModel {
  final int id;
  final String label;
  final String text;
  final String image;
  final String date;

  NewsModel({
    required this.id,
    required this.label,
    required this.text,
    required this.image,
    required this.date,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      text: json['text'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
