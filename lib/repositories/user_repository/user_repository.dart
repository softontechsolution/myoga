
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myoga/configMaps.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import '../../services/controllers/Data_handler/appData.dart';
import '../../services/models/booking_model.dart';
import '../../services/models/package_details_model.dart';
import '../../services/models/user_model.dart';
import '../../services/views/Select_Ride/select_ride_screen.dart';
import '../authentication_repository/authentication_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

//Here performs the database operations

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _authRepo = Get.put(AuthenticationRepository());

  ///Stores users info in FireStore
  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).whenComplete(() => Get.snackbar(
        "Success", "Your account have been created.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green),

    )
        .catchError((error, stackTrace) {
          Get.snackbar("Error", "Something went wrong. Try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
    });
  }

  ///Fetch  User Details
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  ///Fetch All Users
  Future<List<UserModel>> getAllUserDetails() async {
    final snapshot = await _db.collection("Users").get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  ///Updating User Details
  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }

  ///Updating Phone Number
  Future<void> updatePhone(String phone) async {
    final email = _authRepo.firebaseUser.value?.email;
   UserModel userInfo = await getUserDetails(email!) ;
    final updateInfo = _db.collection("Users").doc(userInfo.id);
    await updateInfo.update({'Phone': phone}).then((value) => Get.snackbar(
        "Good", "Phone Number Accepted",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green),
    ).catchError((error, setTrack){
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    });
  }

  ///Saving Booking Information
  saveBookingRequest(BookingModel bookings) async {
    ///FirebaseDatabase.instance.ref().child('Booking Request').push();
    await _db.collection("Bookings").add(bookings.toJson()).whenComplete(() => Get.snackbar(
        "Success", "Your booking have been received",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    });
  }

  ///Saving Package Details
  savePackageDetail(PackageDetails package) async {
    await _db.collection("Packages").add(package.toJson()).whenComplete(() => Get.snackbar(
        "Success", "Package Details Received",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
    });
  }

  ///Retrieving Package Details From Database
  Future<List<PackageDetails>>getPackageDetails() async {
    final email = _authRepo.firebaseUser.value?.email;
    UserModel userInfo = await getUserDetails(email!);
    final snapshot = await _db.collection("Packages").where("Customer", isEqualTo: userInfo.id).get();
    final packageData = snapshot.docs.map((e) => PackageDetails.fromSnapshot(e)).toList();
    return packageData;
  }


  Future<List<BookingModel>>getUserBookingDetails() async {
    final email = _authRepo.firebaseUser.value?.email;
    UserModel userInfo = await getUserDetails(email!);
    final snapshot = await _db.collection("Bookings").where("Customer ID", isEqualTo: userInfo.id).get();
    final bookingData = snapshot.docs.map((e) => BookingModel.fromSnapshot(e)).toList();
    return bookingData;
  }

}
