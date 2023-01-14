import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/repositories/authentication_repository/authentication_repository.dart';

import '../views/Dashboard/dashboard.dart';
import '../views/User_Dashboard/user_dashboard.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const UserDashboard()) : Get.back();
  }

}