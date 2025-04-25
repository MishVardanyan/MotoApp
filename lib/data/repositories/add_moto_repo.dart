import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit_demo/services/auth_service.dart';

Future<int?> addMoto(String vin) async {
  final url = Uri.parse('http://5.188.114.223:4000/api/motos/attach');
    final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',},
      body: jsonEncode({
        'vin':vin 
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      
    return 200;
    }
  } catch (e) {
    return 500; 
  }
}
