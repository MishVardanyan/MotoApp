import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_track/data/models/trip_history_model.dart';

/// Получение списка поездок по ID мотоцикла и дате
Future<TripListModel> fetchTripData(String id, DateTime date) async {
  final formattedDate =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  final url = Uri.parse('http://5.188.114.223:4000/api/motos/$id/$formattedDate');
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final tripList = TripListModel.fromJson(data); //  модель списка поездок
      return tripList;
    } else if (response.statusCode == 401) {
      throw Exception('Несанкционированный доступ!');
    } else {
      throw Exception('Ошибка API: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Ошибка API: $e');
    rethrow;
  }
}
