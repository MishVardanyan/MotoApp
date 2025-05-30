import 'package:moto_track/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'presentation/navigation/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AuthService.loadToken();
if (await AuthService.hasCredentials()) {
  await AuthService.autoLogin();
}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
