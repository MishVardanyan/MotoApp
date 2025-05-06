import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavScreen extends StatefulWidget {
  final Widget child;
  const BottomNavScreen({required this.child, super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int refreshCounter = 0;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int selectedIndex = 1;
    if (location.startsWith('/news')) selectedIndex = 0;
    if (location.startsWith('/home')) selectedIndex = 1;
    if (location.startsWith('/account')) selectedIndex = 2;

    final List<String> _labels = ['НОВОСТИ', 'ТРАНСПОРТ', 'АККАУНТ'];
    final List<String> _icons = [
      "assets/icons/news_icon.png",
      "assets/icons/bike_icon.png",
      "assets/icons/account_icon.png"
    ];

    void _onItemTapped(int index) {
      final currentLocation = GoRouterState.of(context).uri.toString();

      switch (index) {
        case 0:
          if (currentLocation != '/news') {
            context.go('/news');
          }
          break;

        case 1:
          if (currentLocation == '/home') {
            setState(() {
              refreshCounter++; // 🔁 թարմացնում է child-ը
            });
          } else {
            context.go('/home');
          }
          break;

        case 2:
          if (currentLocation != '/account') {
            context.go('/account');
          }
          break;
      }
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Builder(
          builder: (context) => Container(
            key: ValueKey('home-$refreshCounter-$location'),
            child: widget.child,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_labels.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: MediaQuery.of(context).size.width / 3,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFCC0001) : Colors.grey[300],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage(_icons[index]),
                      color: isSelected ? Colors.white : Colors.black,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
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
