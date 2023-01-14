import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/models/user_model.dart';

//Here performs the database operations

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  ///Stores users info in FireStore
  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson()).whenComplete(() => Get.snackbar(
        "Success", "Your account have been created.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green),

    )
        .catchError((error, stackTrace) {
          Get.snackbar("Error", "Something went wrong. Try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.red);
          print(error.toString());
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

  Future<void> updatePhone(phoneNumber) async {
    UserModel user = const UserModel();
    await _db.collection("Users").doc(user.id).update({"Phone": phoneNumber });
  }


}
