import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavScreen extends StatelessWidget {
  final Widget child;
  
  const BottomNavScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    String route = '';
    final location =route= GoRouterState.of(context).uri.toString();
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
      if (route =="/news" || route =="/account"){
        context.pop();
      } 
      switch (index) {
        case 0:
          context.push('/news');
          break;
        case 1:
          context.go('/home');
          break;
        case 2:
          context.push('/account');
          break;
      }
    }

    return Scaffold(
      body: AnimatedSwitcher(
  duration: Duration(milliseconds: 400),
  switchInCurve: Curves.easeIn,
  switchOutCurve: Curves.easeOut,
  transitionBuilder: (child, animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
  child: child,
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
  width: MediaQuery.of(context).size.width/3,
  padding: const EdgeInsets.symmetric(vertical: 12),
  decoration: BoxDecoration(
    color: isSelected ? const Color(0xFFCC0001) : Colors.grey[300],
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
