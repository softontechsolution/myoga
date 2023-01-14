import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/repositories/authentication_repository/authentication_repository.dart';

import '../../repositories/user_repository/user_repository.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();


  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  /// Get User Email and Pass it to UserRepository to fetch user record.
  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to Continue");
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.getAllUserDetails();
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

}