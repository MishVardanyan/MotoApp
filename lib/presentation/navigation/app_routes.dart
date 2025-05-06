import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yandex_mapkit_demo/data/models/moto_model.dart';
import 'package:yandex_mapkit_demo/presentation/screens/auth/login_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/auth/register_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/home/home_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/news/news_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/account/account_screen.dart';
import 'package:yandex_mapkit_demo/presentation/navigation/bottom_nav_bar.dart';
import 'package:yandex_mapkit_demo/presentation/screens/trip/route_screen.dart';
import 'package:yandex_mapkit_demo/presentation/screens/vehicle/vehicle_details_screen.dart';
import 'package:yandex_mapkit_demo/services/auth_service.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>();
final _shellNavigatorNewsKey = GlobalKey<NavigatorState>();
final _shellNavigatorAccountKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,

  redirect: (context, state) {
    final loggedIn = AuthService.isLoggedIn;
    final loggingIn = state.uri.path == '/login' || state.uri.path == '/register';

    if (!loggedIn && !loggingIn) return '/login';
    if (loggedIn && loggingIn) return '/home';
    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildTransitionPage(state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _buildTransitionPage(state, const RegisterScreen()),
    ),
    
    ShellRoute(
      builder: (context, state, child) => BottomNavScreen(child: child),
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorNewsKey,
          builder: (context, state, child) => child,
          routes: [
            GoRoute(
              path: '/news',
              pageBuilder: (context, state) => _buildTransitionPage(state, const NewsScreen()),
            ),
          ],
        ),

        ShellRoute(
          navigatorKey: _shellNavigatorHomeKey,
          builder: (context, state, child) => child,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _buildTransitionPage(state, HomeScreen()),
              routes: [
                GoRoute(
                  path: 'moto-details',
                  pageBuilder: (context, state) {
                    final moto = state.extra as MotoModel;
                    return _buildTransitionPage(state, MotoDetailsScreen(moto: moto));
                  },
                  routes: [
                    GoRoute(
                      path: 'route',
                      pageBuilder: (context, state) {
                        final data = state.extra as Map<String, dynamic>;
                        return _buildTransitionPage(
                          state,
                          RouteScreen(
                            routeId: data['routeId'],
                            motoName: data['motoName'],
                            index: data['index'],
                            date: data['date'],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        ShellRoute(
          navigatorKey: _shellNavigatorAccountKey,
          builder: (context, state, child) => child,
          routes: [
            GoRoute(
              path: '/account',
              pageBuilder: (context, state) => _buildTransitionPage(state, const AccountScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);

CustomTransitionPage _buildTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0), // from right
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}
,
    transitionDuration: const Duration(milliseconds: 400),
  );
}