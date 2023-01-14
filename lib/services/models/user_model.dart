//Creating User Model

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? fullname;
  final String? email;
  final String? password;
  final String? phoneNo;
  final String? address;

  const UserModel({
    this.id,
    this.fullname,
    this.email,
    this.password,
    this.phoneNo,
    this.address,
  });

  toJson() {
    return {
      "ID": id,
      "FullName": fullname,
      "Email": email,
      "Password": password,
      "Phone": phoneNo,
      "Address": address,
    };
  }

  /// Map user fetched from Firebase to UserModel

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document)
  {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      password: data["Password"],
      fullname: data["FullName"],
      phoneNo: data["Phone"],
      address: data["Address"],
    );
  }

}