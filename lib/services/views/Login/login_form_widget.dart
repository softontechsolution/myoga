import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/colors.dart';
import '../../../constants/texts_string.dart';
import '../../controllers/login_controller.dart';
import '../Dashboard/dashboard.dart';
import '../Forget_Password/Forget_Password_Options/forget_password_btn_widget.dart';
import '../Forget_Password/Forget_Password_Options/forget_password_model_bottom_sheet.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final _formkey = GlobalKey<FormState>();

    return Form(
      key: _formkey,
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
              validator: (value){
                if(value == null || value.isEmpty)
                  {
                    return "Please enter email";
                  }
                    return null;
              },
              controller: controller.email,
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
              validator: (value){
                if(value == null || value.isEmpty)
                {
                  return "Please enter your password";
                }
                return null;
              },
              controller: controller.password,
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
              child: ElevatedButton(onPressed: (){
                if(_formkey.currentState!.validate()){
                  LoginController.instance.loginUsers(controller.email.text.trim(), controller.password.text.trim());
                }
              },
                  child: Text(moLogin.toUpperCase(), style: const TextStyle(fontSize: 20.0,),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}



