import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen {
  Future<DateTime?> showCalendarDialog(BuildContext context) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = DateTime.now(); // Սկզբնական արժեք

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Выберите дату"),
              content: SizedBox(
                width: 300,
                height: 400,
                child: TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: selectedDate,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                  calendarFormat: CalendarFormat.month,
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFFF3D34C), 
                      shape: BoxShape.circle, 
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color(0xFFF3D39C), 
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null), // Վերադարձնել null եթե չընտրեն
                  child: Text("Закрыть"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selectedDate), // Վերադարձնել ընտրված օրը
                  child: Text("Выбрать"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
