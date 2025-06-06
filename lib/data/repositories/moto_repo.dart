import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_track/data/models/moto_model.dart';


/// Получение данных о мотоциклах пользователя
Future<List<MotoModel>> fetchMotoData() async {
  final url = Uri.parse('http://5.188.114.223:4000/api/motos/user');
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
      List<MotoModel> motos = (data as List)
          .map((item) => MotoModel.fromJson(item))
          .toList();
      return motos;
    } else if (response.statusCode == 401) {
      throw Exception('Несанкционированный доступ! Пожалуйста, войдите снова.');
    } else {
      throw Exception('Ошибка запроса к API: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Ошибка API: $e');
    rethrow;
  }
}
