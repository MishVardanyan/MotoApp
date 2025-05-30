import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_track/consts/server_consts.dart';
import 'package:moto_track/data/models/moto_data_model.dart';
import 'package:moto_track/data/models/moto_model.dart';
import 'package:moto_track/data/models/trip_history_model.dart';
import 'package:moto_track/data/repositories/trip_history_repo.dart';
import 'package:moto_track/presentation/screens/vehicle/trip_history_screen.dart';

class MotoDetailsScreen extends StatefulWidget {
  final MotoModel moto;
  const MotoDetailsScreen({super.key, required this.moto});
  @override
  State<StatefulWidget> createState() => _MotoDetailsScreen();
}

class _MotoDetailsScreen extends State<MotoDetailsScreen> {
  final GlobalKey _bodyKey = GlobalKey();
  double bodyHeight = 0;
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

  List<TripModel> routes = [];

  late String currentMonth;
  int selectedMonth = 0;
  late DateTime now;
  late int currentYear;
  late int currentDay;
  late int weekday;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    selectedDate = now;
    currentMonth = russianMonths[now.month - 1].toString();
    currentYear = now.year;
    currentDay = now.day;
    weekday = now.weekday;
    fetchTrips();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _bodyKey.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        setState(() {
          bodyHeight = box.size.height;
        });
      }
    });
  }

  Future<void> fetchTrips() async {
    final result = await fetchTripData(widget.moto.id, selectedDate);
    setState(() {
      routes = result.trips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          key: _bodyKey,
          padding: EdgeInsets.only(
            bottom: max(0, MediaQuery.of(context).size.height - bodyHeight),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.31,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(widget.moto.model.imageUrl),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
              Column(mainAxisSize: MainAxisSize.max, children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.moto.model.name,
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
                              
                              Text(widget.moto.year?.toString()??'Неизвестно'),
                              SizedBox(
                                height: 30,
                              ),
                              Text('Макс. скорость',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                           Text((widget.moto.model.maxSpeed?.toString() ?? 'Неизвестно') + "  км/ч"),

                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mощность',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text((widget.moto.model.engineCapacity?.toString() ?? 'Неизвестно') + " л/с"),

                              SizedBox(
                                height: 30,
                              ),
                              Text('Вес',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text((widget.moto.model.weight?.toString()?? 'Неизвестно') +'кг')
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
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? selected = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      initialEntryMode:
                                          DatePickerEntryMode.calendarOnly,
                                    );

                                    if (selected != null) {
                                      selectedDate = selected;
                                      await fetchTrips();
                                      setState(() {
                                        selectedDate = selected;
                                        currentYear = selected.year;
                                        currentDay = selected.day;
                                        currentMonth =
                                            russianMonths[selected.month - 1]
                                                .toString();
                                        weekday = selected.weekday;
                                        selectedMonth = selected.month;
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
                                              ? (currentDay - (5 - index))
                                                  .toString()
                                              : (DateTime(currentYear,
                                                              selectedMonth, 0)
                                                          .day +
                                                      (currentDay -
                                                          (5 - index)))
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
              ])
            ],
          )),
      bottomSheet: TripHistoryWidget(
          routes: routes,
          motoName: widget.moto.model.name,
          bodyHeight: bodyHeight),
    ));
  }
}
