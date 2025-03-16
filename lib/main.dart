import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';

void main() {
  AndroidYandexMap.useAndroidViewSurface = true;
  runApp(const MaterialApp(home: MainScreen()));
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(bottomNavigationBar: BottomNavScreen(),),
      
    );
  }
}
