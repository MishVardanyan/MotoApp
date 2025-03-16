import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/data/models/moto_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final List<MotoModel> motos = [
    MotoModel(
        id: "151zxc482",
        model: "Ducati Monster",
        createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(
        id: "151zxc482",
        model: "Ducati Monster",
        createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(
        id: "151zxc482",
        model: "Ducati Monster",
        createdAt: "2024-02-01T12:00:00Z"),
    MotoModel(
        id: "151zxc482",
        model: "Ducati Monster",
        createdAt: "2024-02-01T12:00:00Z")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const SafeArea(child: YandexMap()),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 230,
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                  color: Color(0xffF3D34C),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
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
              Expanded(
                  child: ListView.builder(
                itemCount: motos.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 59,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(
                          leading: Image.asset("assets/icons/progasi_test.png"),
                          title: Text(motos[index].model),
                          subtitle: Text(motos[index].createdAt),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[300]),
                    ],
                  );
                },
              ))
            ],
          ),
        ));
  }
}
