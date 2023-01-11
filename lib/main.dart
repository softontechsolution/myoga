import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/repositories/authentication_repository/authentication_repository.dart';
import 'package:myoga/services/controllers/Data_handler/appData.dart';
import 'package:myoga/services/controllers/otp_controller.dart';
import 'package:myoga/services/views/User_Dashboard/user_dashboard.dart';
import 'package:myoga/utils/themes/theme.dart';
import 'firebase_options.dart';
import 'services/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.put(OTPController());
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: GetMaterialApp(
        theme: MyOgaTheme.lightTheme,
        darkTheme: MyOgaTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 100),
        home:const UserDashboard(),
      ),
    );
  }
}
