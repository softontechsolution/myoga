import 'package:flutter/material.dart';

import '../../../constants/texts_string.dart';

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({
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
                  label: Text(moFullName),
                  prefixIcon: Icon(Icons.person_outline_outlined)),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(moEmail),
                  prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
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
                onPressed: () {},
                child: Text(moSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
