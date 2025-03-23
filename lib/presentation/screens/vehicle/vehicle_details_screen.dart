import 'package:flutter/material.dart';
import 'package:yandex_mapkit_demo/data/models/moto_data_model.dart';
import 'package:yandex_mapkit_demo/data/models/route_model.dart';
import 'package:yandex_mapkit_demo/presentation/screens/vehicle/calendar_screen.dart';

class MotoDetailsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MotoDetailsScreen();
}

class _MotoDetailsScreen extends State<MotoDetailsScreen> {
  final List<MotoDataModel> motoList = [
    MotoDataModel(
      model: "PROGASI MAX 150",
      year: 2025,
      specifications: Specifications(
        spec1: "250cc",
        spec2: "5-ступенчатая",
        spec3: "Вес: 115 кг",
      ),
      tripHistory: TripHistory(
        month: "Апрель",
        year: 2024,
        dates: [8, 9, 10, 11, 12, 13, 14],
      ),
      routes: [
        MotoRoute(routeNumber: 1, time: "10:00-11:00"),
        MotoRoute(routeNumber: 2, time: "15:00-16:00"),
      ],
      status: "В рабочем состоянии",
    ),
  ];
  List<String> russianMonths = [
    "Январь",
    "Февраль",
    "Март",
    "Апрель",
    "Май",
    "Июнь",
    "Июль",
    "Август",
    "Сентябрь",
    "Октябрь",
    "Ноябрь",
    "Декабрь"
  ];
  List<String> shortWeekDaysRu = ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"];
  List<RouteModel> routes = [
    RouteModel(title: "МАРШРУТ 1", time: "08:00-09:00"),
    RouteModel(title: "МАРШРУТ 2", time: "10:00-11:00"),
    RouteModel(title: "МАРШРУТ 3", time: "12:00-13:00"),
    RouteModel(title: "МАРШРУТ 4", time: "14:00-15:00"),
    RouteModel(title: "МАРШРУТ 5", time: "16:00-17:00"),
    RouteModel(title: "МАРШРУТ 6", time: "18:00-19:00"),
    RouteModel(title: "МАРШРУТ 7", time: "20:00-21:00"),
  ];

  double _bottomSheetHeight = 230;

  late String currentMonth;
  late int selectedMonth;
  late DateTime now;
  late int currentYear;
  late int currentDay;
  late int weekday;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    currentMonth = russianMonths[now.month - 1].toString();
    currentYear = now.year;
    currentDay = now.day;
    weekday = now.weekday;
  }

  void toggleBottomSheet() {
    setState(() {
      _bottomSheetHeight =
          (_bottomSheetHeight == 230) ? 50 : 230; // Փոխում ենք բարձրությունը
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: 
          Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset('assets/images/moto_test.png'),
                ),
              ),
              Positioned(
                top: 20,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    motoList[0].model,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Год выпуска',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(motoList[0].year.toString()),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Коробка передач',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(motoList[0].specifications.spec2)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Тип мотора',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(motoList[0].year.toString()),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Вес',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(motoList[0].specifications.spec3)
                      ],
                    ),
                  ],
                ),
                
                Divider(
                  height: 5,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
              alignment: Alignment.centerLeft,
              padding:EdgeInsets.only(left: 20, right: 20, bottom: 20),
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "ИСТОРИЯ ПОЕЗДОК",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      currentMonth + " " + currentYear.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF949494),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      7,
                      (index) => Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: 47,
                          decoration: BoxDecoration(
                            color: index == 5
                                ? Color(0xFFF3D34C)
                                : Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await CalendarScreen()
                                  .showCalendarDialog(context);
                              if (selectedDate != null) {
                                setState(() {
                                  currentYear = selectedDate.year;
                                  currentDay = selectedDate.day;
                                  currentMonth =
                                      russianMonths[selectedDate.month - 1]
                                          .toString();
                                  weekday = selectedDate.weekday;
                                  selectedMonth = selectedDate.month;
                                });
                              }
                            },
                            child: Column(
                              children: [
                                if (index == 5) ...[
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(shortWeekDaysRu[weekday % 7],
                                      style: TextStyle(
                                        fontSize: 8,
                                      )),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(currentDay.toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ] else if (index < 5) ...[
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                      shortWeekDaysRu[
                                          (weekday - (5 - index)) % 7],
                                      style: TextStyle(
                                        fontSize: 8,
                                      )),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    ((currentDay - (5 - index)) > 0)
                                        ? (currentDay - (5 - index)).toString()
                                        : (DateTime(currentYear, selectedMonth,
                                                        0)
                                                    .day +
                                                (currentDay - (5 - index)))
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ] else ...[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Выбрать",
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  Text(
                                    "дату",
                                    style: TextStyle(fontSize: 8),
                                  )
                                ],
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              )),
        ],
      )),
      bottomSheet: AnimatedContainer(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.zero),
            color: Color(0xFFF5F5F5)),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width,
        height: 65*2,
        padding: EdgeInsets.only(top: 22, left: 25, right: 25),
        clipBehavior: Clip.none,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: 65,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${routes[index].title}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              Row(
                                children: [
                                  ImageIcon(
                                      AssetImage('assets/icons/time_icon.png')),
                                  SizedBox(width: 5),
                                  Text(
                                    routes[index].time,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Divider(
                              height: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
