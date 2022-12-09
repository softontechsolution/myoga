import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/texts_string.dart';
import '../../controllers/signup_controller.dart';
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
              controller: controller.name,
              decoration: const InputDecoration(
                  label: Text(moFullName),
                  prefixIcon: Icon(Icons.person_outline_outlined)),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  label: Text(moEmail),
                  prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: controller.password,
              decoration: const InputDecoration(
                  label: Text(moPassword),
                  prefixIcon: Icon(Icons.fingerprint_outlined)),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moRepeatPassword),
                  prefixIcon: Icon(Icons.fingerprint_outlined)),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(_formkey.currentState!.validate()){
                    SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                  }
                  //Get.to(() => const PhoneNumberScreen());
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
