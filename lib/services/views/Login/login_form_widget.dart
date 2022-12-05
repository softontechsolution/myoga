import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/texts_string.dart';
import '../Forget_Password/Forget_Password_Options/forget_password_btn_widget.dart';
import '../Forget_Password/Forget_Password_Options/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: moEmail,
                hintText: moEmail,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0,),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined),
                labelText: moPassword,
                hintText: moPassword,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye_sharp),
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: (){
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: const Text(moForgetPassword, style: TextStyle(color: moAccentColor),),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: (){},
                  child: Text(moLogin.toUpperCase(), style: const TextStyle(fontSize: 20.0,),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}



