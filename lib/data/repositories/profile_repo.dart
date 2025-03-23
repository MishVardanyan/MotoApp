import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit_demo/data/models/user_model.dart'; // փոխիր ըստ քո ֆոլդերի

Future<ProfileModel?> fetchProfileData() async {
  final url = Uri.parse('http://5.188.114.223:4000/api/users/profile');
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
      final profile = ProfileModel.fromJson(data);
      return profile;
    } else if (response.statusCode == 401) {
      throw Exception('Անթույլատրելի մուտք! Խնդրում ենք կրկին մուտք գործել');
    } else {
      throw Exception('API հարցման սխալ: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ API Error: $e');
    return null;
  }
}
