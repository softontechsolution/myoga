import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:myoga/services/views/Profile/profile_info_screen.dart';
import 'package:myoga/services/views/Profile/update_profile_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';
import '../../../repositories/authentication_repository/authentication_repository.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(moProfile, style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
                  Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [

              Stack(
                children: [
                  SizedBox(
                    width: 120.0,
                    height: 120.0,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(moProfilePic))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: moSecondarColor),
                        child: const Icon(LineAwesomeIcons.alternate_pencil,
                            size: 20.0, color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(moProfileHeading,
                  style: Theme.of(context).textTheme.headline4),
              Text(moProfileSubheading,
                  style: Theme.of(context).textTheme.bodyText2),
              const SizedBox(height: 10.0),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () { Get.to(() => const UpdateProfileScreen()); },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PButtonColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(moEditProfile,
                      style: TextStyle(color: PWhiteColor)),
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 10.0),
              //Menu
              ProfileMenuWidget(
                  title: moMenu1, icon: LineAwesomeIcons.user, onPress: () {
                    Get.to(() => const ProfileInformation());
              }),
              ProfileMenuWidget(
                  title: moMenu2,
                  icon: LineAwesomeIcons.receipt,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: moMenu5, icon: LineAwesomeIcons.wallet, onPress: () {}),
              ProfileMenuWidget(
                  title: moMenu3, icon: LineAwesomeIcons.cog, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10.0),
              ProfileMenuWidget(
                title: moMenu4,
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  AuthenticationRepository.instance.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


