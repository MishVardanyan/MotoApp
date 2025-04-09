import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit_demo/data/models/route_model.dart';
import 'package:yandex_mapkit_demo/data/models/trip_history_model.dart';
import 'package:yandex_mapkit_demo/presentation/screens/trip/route_screen.dart';

class TripHistoryWidget extends StatelessWidget {
  final List<TripModel> routes;
  final String motoName;
  final double bodyHeight;

  const TripHistoryWidget(
      {super.key, required this.routes, required this.motoName,required this.bodyHeight});

  String formatTimeRange(DateTime start, DateTime end) {
    String formatTime(DateTime time) {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }

    return '${formatTime(start)} – ${formatTime(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.zero),
        color: Color(0xFFF5F5F5),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: MediaQuery.of(context).size.width,
      height: (bodyHeight> 750)
    ? 140 // default height
    : max(0, MediaQuery.of(context).size.height - bodyHeight),

      padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
      clipBehavior: Clip.none,
      child: Column(
        children: [
          Expanded(
              child: routes.isEmpty
                  ? const Center(child: Text('Нет маршрутов'))
                  : ListView.builder(
                      itemCount: routes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.push(
  '/home/moto-details/route',
  extra: {
    'routeId': routes[index].routeId,
    'motoName': motoName,
    'index': index,
    'date': formatTimeRange(
      routes[index].startTime,
      routes[index].endTime,
    ),
  },
);

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            height: 65,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Маршрут ${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const ImageIcon(
                                          AssetImage(
                                              'assets/icons/time_icon.png'),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          formatTimeRange(
                                              routes[index].startTime,
                                              routes[index].endTime),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    const Icon(Icons.arrow_forward_ios),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Divider(
                                  height: 1,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
        ],
      ),
    );
  }
}
