import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/texts_string.dart';
import '../../controllers/signup_controller.dart';
import '../../models/user_model.dart';
import '../Forget_Password/Forget_Password_Otp/otp_screen.dart';
import '../Login/login_screen.dart';
import '../Phone_Number_Screen/phone_number.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formkey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moFullName),
                  prefixIcon: Icon(Icons.person_outline_outlined)),
              validator: (value){
                if(value == null || value.isEmpty)
                {
                  return "Please enter your full name";
                }
                return null;
              },
              controller: controller.name,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moEmail),
                  prefixIcon: Icon(Icons.email_outlined)),
              validator: (value){
                if(value == null || value.isEmpty)
                {
                  return "Please enter your email";
                }
                return null;
              },
              controller: controller.email,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moPassword),
                  prefixIcon: Icon(Icons.fingerprint_outlined)),
              validator: (value){
                if(value == null || value.isEmpty)
                {
                  return "Please enter your password";
                }
                return null;
              },
              controller: controller.password,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text(moRepeatPassword),
                  prefixIcon: Icon(Icons.fingerprint_outlined)),
              validator: (value){
                if(value != controller.password.text.trim())
                {
                  return "Password not match";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if(_formkey.currentState!.validate()){

                    final user = UserModel(
                      email: controller.email.text.trim(),
                      fullname: controller.name.text.trim(),
                      password: controller.password.text.trim(),
                    );
                    await SignUpController.instance.createUser(user);
                    SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                  }
                },
                child: Text(moNext.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
