class MotoDataModel {
  final String model;
  final int year;
  final Specifications specifications;
  final TripHistory tripHistory;
  final List<MotoRoute> routes;
  final String status;

  MotoDataModel({
    required this.model,
    required this.year,
    required this.specifications,
    required this.tripHistory,
    required this.routes,
    required this.status,
  });
}

class Specifications {
  final String spec1;
  final String spec2;
  final String spec3;

  Specifications({
    required this.spec1,
    required this.spec2,
    required this.spec3,
  });
}

class TripHistory {
  final String month;
  final int year;
  final List<int> dates;

  TripHistory({
    required this.month,
    required this.year,
    required this.dates,
  });
}

class MotoRoute {
  final int routeNumber;
  final String time;

  MotoRoute({
    required this.routeNumber,
    required this.time,
  });
}

