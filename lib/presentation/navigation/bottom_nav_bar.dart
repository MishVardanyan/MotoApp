import 'package:flutter/material.dart';
import 'package:yandex_mapkit_demo/presentation/screens/account/account_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/home/home_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/news/news_screen.dart';
class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    NewsScreen(),
    HomeScreen(),
    AccountScreen(),
  ];

  final List<String> _labels = ['НОВОСТИ', 'ТРАНСПОРТ', 'АККАУНТ'];
  final List<String> _icons = [
    "assets/icons/news_icon.png",
    "assets/icons/bike_icon.png",
    "assets/icons/account_icon.png"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, 
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_labels.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFCC0001) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(AssetImage(_icons[index]), color: isSelected ? Colors.white : Colors.black, size: 28),
                    SizedBox(height: 4),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}