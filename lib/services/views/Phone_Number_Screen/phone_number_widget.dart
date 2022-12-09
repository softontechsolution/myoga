import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/texts_string.dart';
import '../../controllers/signup_controller.dart';
import '../Forget_Password/Forget_Password_Otp/otp_screen.dart';
import '../Login/login_screen.dart';

class PhoneNumberFormWidget extends StatelessWidget {
  const PhoneNumberFormWidget({
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
              controller: controller.phoneNo,
              decoration: const InputDecoration(
                  label: Text(moPhone),
                  prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 10.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  SignUpController.instance.phoneAuthentication(controller.phoneNo.text.trim());
                  Get.to(() => const OTPScreen());
                },
                child: Text(moSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
