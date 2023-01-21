import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:myoga/services/views/Profile/update_profile_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/texts_string.dart';
import '../../../constants/image_strings.dart';
import '../Forget_Password/Change Password/change_password.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title:
            Text(moProfileInfo, style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const UpdateProfileScreen());
              },
              icon: const Icon(LineAwesomeIcons.edit)),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage(moProfilePic))),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(moProfilePics, style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 15.0),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 14,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(moProfileInfoHead, style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: const [
                      Text(moProfileName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("John Doe",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Text(moProfileEmail,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("john@gmail.com",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Text(moProfilePhone,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("(234) 8123334540",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Text(moProfileDOB,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("10/10/2001",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Text(moProfileAddress,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("No.33 Gwari, Abuja",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: const [
                      Text(moProfileGender,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Mail",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(onPressed: (){
                    Get.to(()=> const ChangePasswordScreen());
                  },
                      child: const Text("Change Password", style: TextStyle(color: moAccentColor,fontSize: 20,
                          fontWeight: FontWeight.w400),
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
