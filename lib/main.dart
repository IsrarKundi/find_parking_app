import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import for GetMaterialApp
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'views/screens/splash/splash_screen.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
    "pk.eyJ1IjoiaXNyYXJrMzEzIiwiYSI6ImNtZmg2ZnpieDA4MmIyanF0cGJheThyYXEifQ.BFlPl5Zn1zSIVkcb4hMzDQ"
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp( // Replace MaterialApp with GetMaterialApp
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}


