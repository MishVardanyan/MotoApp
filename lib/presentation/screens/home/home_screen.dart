import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/data/models/moto_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/moto_repo.dart';
import 'package:yandex_mapkit_demo/data/repositories/trip_history_repo.dart';
import 'package:yandex_mapkit_demo/presentation/screens/vehicle/vehicle_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
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
    loadMotos();
  }



  Future<void> loadMotos() async {
    motos = await fetchMotoData();
    setState(() {
      for (var element in motos) {
        if(element.currentLocation?.latitude!=null&&element.currentLocation?.longitude!=null){
        _placemarks.add(
              PlacemarkMapObject(
        text: PlacemarkText(
          text: '${element.model.name}\n${''}\n${'Ленинский'}',
          style: PlacemarkTextStyle(
            size: 12,
            color: Colors.black,
            outlineColor: Colors.white,
            placement: TextStylePlacement.right,
            offset: -15.0,
            offsetFromIcon: true
          ),
        ),
        mapId: MapObjectId('point_${element.id}'),
        point: Point(latitude: element.currentLocation!.latitude, longitude: element.currentLocation!.longitude), // Yerevan
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/icons/geo_icon.png'),
          scale: 4.0,
          anchor: Offset(0.2, 0.9)
        )),
        opacity: 1.0,
        onTap: (mapObject, point) {
  //context.push('/home/moto-details', extra: element);

},
),
        );
      }}
    });
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

  final List<PlacemarkMapObject> _placemarks = [
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: double.infinity,
      body: SafeArea(
        child: YandexMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            await _mapController.moveCamera(
              CameraUpdate.newCameraPosition(
                const CameraPosition(
                  target:
                      Point(latitude: 55.7558, longitude: 37.6173), 
                  zoom: 8.0,
                ),
              ),
              animation: const MapAnimation(
                  type: MapAnimationType.smooth, duration: 1),
            );
            
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
              child: Column(
                children: [
                  Container(
                    height: 20,
                    child: IconButton(
                      icon: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xFF6C6C6C),
                        ),
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 3,
                      ),
                      onPressed: toggleBottomSheet,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "МОЙ ТРАНСПОРТ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
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
                                        borderRadius: BorderRadius.circular(10),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MotoDetailsScreen(moto: motos[index]),

                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
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
