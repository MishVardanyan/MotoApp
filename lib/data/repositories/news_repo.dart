import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit_demo/data/models/news_model.dart';

/// Получение новостей с сервера
Future<List<NewsModel>> fetchNews() async {
  final url = Uri.parse('http://5.188.114.223:4000/api/news');
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
      final newsList = (data['news'] as List)
          .map((item) => NewsModel.fromJson(item))
          .toList();
      return newsList;
    } else if (response.statusCode == 401) {
      throw Exception('Несанкционированный доступ! Пожалуйста, войдите снова.');
    } else {
      throw Exception('Ошибка запроса к API: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Ошибка API: $e');
    return [];
  }
}
