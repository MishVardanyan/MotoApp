import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:moto_track/consts/server_consts.dart';
import 'package:moto_track/data/models/moto_model.dart';
import 'package:moto_track/data/repositories/add_moto_repo.dart';
import 'package:moto_track/data/repositories/moto_repo.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final _trackerIdController = TextEditingController();
  double _bottomSheetHeight = 230;
  List<MotoModel> motos = [];
  void toggleBottomSheet() {
    setState(() {
      _bottomSheetHeight = (_bottomSheetHeight == 230) ? 50 : 230;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  

  double calculateScale(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 3.0 : 4.0;
  }

  Future<void> loadMotos() async {
  motos = await fetchMotoData();
  bool _navigated = false;

  final newPlacemarks = <PlacemarkMapObject>[];
  final points = <Point>[];

  for (var element in motos) {
    final id = 'point_${element.id}';
    final location = element.currentLocation;
    if (location?.latitude != null && location?.longitude != null) {
      points.add(Point(
        latitude: location!.latitude,
        longitude: location.longitude,
      ));

      if (!_placemarks.any((p) => p.mapId.value == id)) {
        newPlacemarks.add(
          PlacemarkMapObject(
            text: PlacemarkText(
              text: '${element.model.name}',
              style: PlacemarkTextStyle(
                size: 12,
                color: Colors.black,
                outlineColor: Colors.white,
                placement: TextStylePlacement.right,
                offset: -15.0,
                offsetFromIcon: true,
              ),
            ),
            mapId: MapObjectId(id),
            point: Point(
              latitude: location.latitude,
              longitude: location.longitude,
            ),
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                    'assets/icons/geo_icon.png'),
                scale: 4.0,
                anchor: Offset(0.2, 0.9),
              ),
            ),
            opacity: 1.0,
            onTap: (mapObject, point) {
              if (_navigated) return;
              _navigated = true;
              context.push('/home/moto-details', extra: element).then((_) {
                _navigated = false;
              });
            },
          ),
        );
      }
    }
  }

  setState(() {
    _placemarks.clear();
    _placemarks.addAll(newPlacemarks);
  });

  if (points.length == 1) {
    await _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: points.first,
          zoom: 15.0,
        ),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 1,
      ),
    );
  } else if (points.length > 1) {
    final minLat = points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    final maxLat = points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    final minLon = points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    final maxLon = points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    final centerLat = (minLat + maxLat) / 2;
    final centerLon = (minLon + maxLon) / 2;
    final maxDiff = [
      (maxLat - minLat).abs(),
      (maxLon - minLon).abs(),
    ].reduce((a, b) => a > b ? a : b);

    double zoom;
    if (maxDiff < 0.01) {
      zoom = 16;
    } else if (maxDiff < 0.05) {
      zoom = 14;
    } else if (maxDiff < 0.1) {
      zoom = 12;
    } else if (maxDiff < 0.5) {
      zoom = 10;
    } else {
      zoom = 8;
    }

    await _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(latitude: centerLat, longitude: centerLon),
          zoom: zoom,
        ),
      ),
      animation: const MapAnimation(
        type: MapAnimationType.smooth,
        duration: 1,
      ),
    );
  }
}


  String _formatLastUsedText(DateTime lastUsed) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final isYesterday = lastUsed.year == yesterday.year &&
        lastUsed.month == yesterday.month &&
        lastUsed.day == yesterday.day;

    if (isYesterday) {
      return 'Последняя активность вчера';
    } else {
      final formattedDate = lastUsed.toIso8601String().split('T')[0];
      return 'Последняя активность $formattedDate';
    }
  }

  late YandexMapController _mapController;

  final List<PlacemarkMapObject> _placemarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: double.infinity,
      body: SafeArea(
        child: YandexMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            await loadMotos();  
          },
          mapObjects: _placemarks,
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width,
        height: _bottomSheetHeight,
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                color: Color(0xffF3D34C),
              ),
              child: Stack(
  children: [
    Positioned(
  top: 7,
  left: MediaQuery.of(context).size.width / 2 - 30,
  child: GestureDetector(
    onTap: toggleBottomSheet, 
    child: Container(
      width: 70,
      height: 6,
      decoration: BoxDecoration(
        color: Color(0xFF6C6C6C),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
),

    Positioned(
      left: 20,
      bottom: 5,
      child: Text(
        "МОЙ ТРАНСПОРТ",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
    Positioned(
      right: 5,
      top: 5,
      child: IconButton(
        icon: Icon(Icons.add, size: 35,color: Colors.black,),
        onPressed: ()=>{showDialog<String>(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: const Text('Добавить транспорт'),
                  content: Container(
                    child: TextFormField(
                controller: _trackerIdController,
                decoration: const InputDecoration(labelText: 'ID транспорта'),
                keyboardType: TextInputType.emailAddress,
                
              ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('отмена'),
                    ),
                    TextButton(
                      onPressed: () async {
  final result = await addMoto(_trackerIdController.text);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result == 200
          ? 'Мотоцикл успешно добавлен'
          : 'неверный трекер ИД',
      ),
    ),
  );
  setState(() {
    
  });
},

                      child: const Text('добавить'),
                    ),
                  ],
                ),
          ),},
      ),
    ),
  ],
),

            ),
            Expanded(
              child: _bottomSheetHeight == 230
                  ? ListView.builder(
                      controller: ScrollController(),
                      itemCount: motos.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 59,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      color: Colors.grey[200],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            motos[index].model.imageUrl,
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  title: Text(motos[index]
                                      .model
                                      .name /*motos[index].model*/),
                                  subtitle: Text(
                                    motos[index].lastUsedAt == null
                                        ? 'последняя активность неизвестно'
                                        : _formatLastUsedText(
                                            motos[index].lastUsedAt!),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  onTap: () {
                                    context.push('/home/moto-details',
                                        extra: motos[index]);
                                  }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(height: 1, color: Colors.grey[300]),
                          ],
                        );
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
