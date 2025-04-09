class TripModel {
  final String routeId;
  final DateTime startTime;
  final DateTime endTime;

  TripModel({
    required this.routeId,
    required this.startTime,
    required this.endTime,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      routeId: json['routeId'] as String,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}

class TripListModel {
  final List<TripModel> trips;

  TripListModel({required this.trips});

  factory TripListModel.fromJson(List<dynamic> json) {
    return TripListModel(
      trips: json.map((item) => TripModel.fromJson(item)).toList(),
    );
  }
}
