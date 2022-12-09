import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/texts_string.dart';
import '../Login/login_screen.dart';

class PhoneNumberFormWidget extends StatelessWidget {
  const PhoneNumberFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moPhone),
                  prefixIcon: Icon(Icons.contact_phone_outlined)),
            ),
            const SizedBox(height: 10.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Get.to(() => const LoginScreen()); },
                child: Text(moSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
