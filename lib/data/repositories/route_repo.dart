import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit_demo/data/models/trip_model.dart';

/// Получение данных маршрута по его ID
Future<List<RouteLocationModel>> fetchRouteData(String routeId) async {
  final url = Uri.parse('http://5.188.114.223:4000/api/motos/routes/$routeId/locations');
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
      final locations = (data as List)
          .map((item) => RouteLocationModel.fromJson(item))
          .toList();
      return locations;
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
