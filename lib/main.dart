import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';
import 'package:yandex_mapkit_demo/presentation/screens/auth/login_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/auth/register_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/vehicle/vehicle_details_screen.dart';

void main() {
  AndroidYandexMap.useAndroidViewSurface = true;
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MaterialApp(home: MainScreen()));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? token;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: token == null ? const LoginScreen() : Scaffold(bottomNavigationBar: BottomNavScreen()),
    );
  }
}
