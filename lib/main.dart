import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/utils/themes/theme.dart';

import 'services/views/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyOgaTheme.lightTheme,
      darkTheme: MyOgaTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
