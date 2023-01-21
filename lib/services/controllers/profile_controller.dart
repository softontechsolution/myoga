import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/repositories/authentication_repository/authentication_repository.dart';

import '../../repositories/user_repository/user_repository.dart';
import '../models/booking_model.dart';
import '../models/package_details_model.dart';
import '../models/user_model.dart';
import 'package:async/async.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();


  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());
  final _memoizer = AsyncMemoizer();

  /// Get User Email and Pass it to UserRepository to fetch user record.
  getUserData() {
    return _memoizer.runOnce(()  async {
      final email = _authRepo.firebaseUser.value?.email;
      if (email != null) {
        return await _userRepo.getUserDetails(email);
      } else {
        Get.snackbar("Error", "Login to Continue");
      }
    });
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.getAllUserDetails();
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  /// Get User Id and Pass it to UserRepository to fetch Package record.
  Future<Future>getPackageData() async {
    return _memoizer.runOnce(()  async {
      final email = _authRepo.firebaseUser.value?.email;
      UserModel userInfo = await _userRepo.getUserDetails(email!);
      if (userInfo != null) {
        //return await _userRepo.getPackageDetails(userInfo.id!);
      } else {
        Get.snackbar("Error", "Can't fetch package");
      }
    });
  }

  Future<List<PackageDetails>> getAllPackage() async {
    return await _userRepo.getPackageDetails();
  }

  Future<List<BookingModel>> getAllUserBookings() async {
    return await _userRepo.getUserBookingDetails();
  }

}