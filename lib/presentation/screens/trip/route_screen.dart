import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/data/models/trip_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/route_repo.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/app_routes.dart';
import 'package:yandex_mapkit_demo/presentation/screens/home/home_screen.dart';

class RouteScreen extends StatefulWidget {
  final String routeId;
  final String motoName;
  final int index;
  final String date;
  const RouteScreen(
      {super.key,
      required this.routeId,
      required this.motoName,
      required this.index, required this.date});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late YandexMapController mapController;
  final MapObjectId polylineId = const MapObjectId('route_line');

  List<MapObject> mapObjects = [];
  List<RouteLocationModel> routePoints = [];

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> fetchRoute() async {
    try {
      final result = await fetchRouteData(widget.routeId);
      routePoints = result;

      if (routePoints.length < 2) return;

      final List<Point> polylinePoints = routePoints.map((e) {
        return Point(latitude: e.latitude, longitude: e.longitude);
      }).toList();

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
                scale: 4.0,
                anchor: Offset(0.2, 0.9)),
          ),
          opacity: 1.0);

      // 👉 End Marker (կարմիր)
      final PlacemarkMapObject endPlacemark = PlacemarkMapObject(
          mapId: const MapObjectId('end_point'),
          point: polylinePoints.last,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image:
                  BitmapDescriptor.fromAssetImage('assets/icons/geo_icon2.png'),
              scale: 4.0,
            ),
          ),
          opacity: 1.0);

      setState(() {
        mapObjects = [polyline, startPlacemark, endPlacemark];
      });

      // 👁 Քարտեզը տեղաշարժում է դեպի սկիզբ
      await mapController.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: polylinePoints.first, zoom: 14),
        ),
      );
    } catch (e) {
      print('⚠️ Error loading route: $e');
    }
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
                        Row(
                          mainAxisSize: MainAxisSize
                              .min, 
                          children: [
                            const ImageIcon(AssetImage('assets/icons/time_icon.png')),
                            const SizedBox(width: 4),
                            Text(
                              widget.date,
                              style: const TextStyle(
                                fontSize: 16,

                              ),
                            ),
                          ],
                        ),
                      ]))
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
