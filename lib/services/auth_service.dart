import 'package:shared_preferences/shared_preferences.dart';
import 'package:moto_track/data/repositories/auth_repo.dart';

class AuthService {
  static String? token;
  static Future<bool> hasCredentials() async {
  final email = await getEmail();
  final password = await getPassword();
  return email != null && password != null;
}

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
  }

  static bool get isLoggedIn => token != null;

  static Future<void> saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    token = newToken;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    token = null;
  }
    static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_email', email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_email');
  }

    static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_password', password);
  }
  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_password');
  }
  
static Future<void> autoLogin() async {
  final email = await getEmail();
  final password = await getPassword();

  if (email != null && password != null) {
    final statusCode = await login(email, password);

    if (statusCode != 200) {
      await logout(); 
    }
  }
}}
