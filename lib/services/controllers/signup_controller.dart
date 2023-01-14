import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:myoga/repositories/authentication_repository/authentication_repository.dart';

import '../../repositories/user_repository/user_repository.dart';
import '../models/user_model.dart';
import '../views/Forget_Password/Forget_Password_Otp/otp_screen.dart';
import '../views/Phone_Number_Screen/phone_number.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //TextField Controller to get data from TextFields
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();

  final userRepo = Get.put(UserRepository());

  // Function to register user using email & password
  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if(error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

  void phoneAuthentication(String phoneNo){
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
    Get.to(() => const OTPScreen());
  }

  updatePhoneNumber(phoneNumber) async {
    await userRepo.updatePhone(phoneNumber);
  }


}