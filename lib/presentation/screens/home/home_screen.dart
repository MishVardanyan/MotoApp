import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/data/models/moto_model.dart';
import 'package:yandex_mapkit_demo/data/repositories/moto_repo.dart';
import 'package:yandex_mapkit_demo/presentation/screens/vehicle/vehicle_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  double _bottomSheetHeight = 230; 

  void toggleBottomSheet() {
    setState(() {
      _bottomSheetHeight = (_bottomSheetHeight == 230) ? 50 : 230;
    });
  }
  @override
  void initState() {
    getMotos();
    super.initState();
  }
  void getMotos() async{
    await fetchMotoData();
  }
  final List<MotoModel> motos = [
    MotoModel(id: "151zxc482", model: "Ducati Monster", createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(id: "151zxc482", model: "Ducati Monster", createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(id: "151zxc482", model: "Ducati Monster", createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(id: "151zxc482", model: "Ducati Monster", createdAt: "2024-02-01T12:00:00Z")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEdgeDragWidth: double.infinity,
      body: const SafeArea(child: YandexMap()),
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 500), 
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
                                leading: Image.asset("assets/icons/progasi_test.png"),
                                title: Text(motos[index].model),
                                subtitle: Text(motos[index].createdAt),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MotoDetailsScreen(),
                    ),
                  );
                },
                              ),
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
