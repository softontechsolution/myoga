import 'package:flutter/material.dart';
import 'package:myoga/services/views/Signup/signup_screen.dart';

import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(moGoogleLogo),
              width: 20.0,
            ),
            onPressed: () {},
            label: const Text(moGoogleSignIn),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        TextButton(
          onPressed: () {
            Get.to(()=> const SignUpScreen());
          },
          child: Text.rich(
            TextSpan(
                text: moDontHaveAccount,
                style: Theme.of(context).textTheme.bodyText1,
                children: const [
                  TextSpan(
                    text: moSignup,
                    style: TextStyle(color: moAccentColor),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }
}
