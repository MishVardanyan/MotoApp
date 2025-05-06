import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/data/models/trip_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/route_repo.dart';
import 'dart:math'; // --- Ավելացրել ենք distance calculation-ի համար

class RouteScreen extends StatefulWidget {
  final String routeId;
  final String motoName;
  final int index;
  final String date;
  const RouteScreen(
      {super.key,
      required this.routeId,
      required this.motoName,
      required this.index,
      required this.date});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late YandexMapController mapController;
  final MapObjectId polylineId = const MapObjectId('route_line');
  double totalDistanceKm = 0;
double averageSpeed = 0;


  List<MapObject> mapObjects = [];
  List<RouteLocationModel> routePoints = [];

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  double calculateScale(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 3.0 : 4.0;
  }

 Future<void> fetchRoute() async {
  try {
    final result = await fetchRouteData(widget.routeId);
    routePoints = result;

    if (routePoints.length < 2) return;

    final List<Point> polylinePoints = routePoints.map((e) {
      return Point(latitude: e.latitude, longitude: e.longitude);
    }).toList();

    // --- Calculate total distance in kilometers
    totalDistanceKm = 0;
    for (int i = 0; i < polylinePoints.length - 1; i++) {
      totalDistanceKm += calculateDistance(
        polylinePoints[i],
        polylinePoints[i + 1],
      );
    }

    // --- Calculate duration in hours using createdAt timestamps
    final startTime = routePoints.first.createdAt;
    final endTime = routePoints.last.createdAt;
    final durationInHours = endTime.difference(startTime).inSeconds / 3600;

    // --- Calculate average speed in km/h
    averageSpeed = durationInHours > 0
        ? totalDistanceKm / durationInHours
        : 0;

    final polyline = PolylineMapObject(
      mapId: polylineId,
      polyline: Polyline(points: polylinePoints),
      strokeColor: Color(0xFFF3D34C),
      strokeWidth: 5,
    );

    final PlacemarkMapObject startPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('start_point'),
        point: polylinePoints.first,
        text: PlacemarkText(
          text: '${widget.motoName}\n${''}\n${'Ленинский'}',
          style: PlacemarkTextStyle(
              size: 12,
              color: Colors.black,
              outlineColor: Colors.white,
              placement: TextStylePlacement.right,
              offset: -14,
              offsetFromIcon: true),
        ),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                  'assets/icons/geo_icon.png'),
              scale: calculateScale(context),
              anchor: Offset(0.2, 0.9)),
        ),
        opacity: 1.0);

    final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('end_point'),
        point: polylinePoints.last,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image:
                BitmapDescriptor.fromAssetImage('assets/icons/geo_icon2.png'),
            scale: calculateScale(context),
          ),
        ),
        opacity: 1.0);

 

    setState(() {
      mapObjects = [polyline, startPlacemark, endPlacemark,];
    });

    await mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: polylinePoints.first, zoom: 14),
      ),
    );
  } catch (e) {
    print('Error loading route: $e');
  }
}


  // --- Distance calculation between two points (in kilometers)
  double calculateDistance(Point a, Point b) {
    const double earthRadius = 6371; // Radius of the Earth in km
    double dLat = _degreesToRadians(b.latitude - a.latitude);
    double dLon = _degreesToRadians(b.longitude - a.longitude);

    double lat1 = _degreesToRadians(a.latitude);
    double lat2 = _degreesToRadians(b.latitude);

    double haversine = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(haversine), sqrt(1 - haversine));
    return earthRadius * c;
  }

  double _degreesToRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF3D34C),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Text(
                          "МАРШРУТ ${widget.index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(children: [ Icon(Icons.access_time),
                            const SizedBox(width: 2),
                            Text(
                              widget.date,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),],),
                            SizedBox(height: 7,),
                           Row(children: [
                            Icon(Icons.route),
                            Text(
                              totalDistanceKm.toStringAsFixed(1)+'км',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 7,),
                            Icon(Icons.speed),
                            Text(
                              averageSpeed.toStringAsFixed(1)+'км/ч',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                           ],)
                           
                            
                          ],
                        ),
                      ])
                      )
                ],
              ),
            ),
            Expanded(
              child: YandexMap(
                onMapCreated: (controller) async {
                  mapController = controller;
                  await mapController.moveCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: Point(latitude: 55.7558, longitude: 37.6173),
                        zoom: 8.0,
                      ),
                    ),
                    animation: const MapAnimation(
                        type: MapAnimationType.smooth, duration: 1),
                  );
                },
                mapObjects: mapObjects,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
