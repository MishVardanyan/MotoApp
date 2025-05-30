import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_track/services/auth_service.dart';

Future<int> login(String email, String password) async {
  final url = Uri.parse('http://5.188.114.223:4000/api/users/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      AuthService.token = token;
    } 

    return response.statusCode;
  } catch (e) {
    return 500; 
  }
}
