import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:myoga/services/views/Profile/update_profile_screen.dart';
import 'package:myoga/services/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';
import '../../../repositories/authentication_repository/authentication_repository.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile_photo_controller.dart';
import '../My_Orders/my_orders_screen.dart';
import '../Wallet_Screen/wallet_screen.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Center(child: Text(moProfile, style: Theme.of(context).textTheme.headline4)),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
                  Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon)),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: ChangeNotifierProvider(
        create: (_) => ProfilePhotoController(),
        child: Consumer<ProfilePhotoController>(
          builder: (context, provider, child){
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: FutureBuilder(
                  future: controller.getUserData(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      if(snapshot.hasData){
                        UserModel userData = snapshot.data as UserModel;

                        return Column(
                          children: [
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 120.0,
                                      height: 120.0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: userData.profilePic == null
                                            ? const Icon(LineAwesomeIcons.user_circle, size: 35,)
                                            : Image(image: NetworkImage(userData.profilePic!),
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child, loadingProgress){
                                              if(loadingProgress == null) return child;
                                              return const Center(child: CircularProgressIndicator());
                                            },
                                            errorBuilder: (context, object, stack){
                                              return const Icon(Icons.error_outline, color: Colors.red,);
                                            },
                                        )
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        provider.pickImage(context);
                                      },
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
                                Text(userData.fullname??"",
                                    style: Theme.of(context).textTheme.headline4),
                                Text(userData.email??"",
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
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const Divider(),
                            const SizedBox(height: 10.0),
                            //Menu
                            ProfileMenuWidget(
                                title: moMenu1, icon: LineAwesomeIcons.user, onPress: () {}),
                            ProfileMenuWidget(
                                title: moMenu2,
                                icon: LineAwesomeIcons.receipt,
                                onPress: () {
                                  Get.to(() => MyOrdersScreen());
                                }),
                            ProfileMenuWidget(
                                title: moMenu5,
                                icon: LineAwesomeIcons.wallet,
                                onPress: () {
                                  Get.to(() => MyWalletScreen());
                                }
                            ),
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
                        );
                      }
                      else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      else {
                        return const Center(child: Text("Something went wrong"));
                      }
                    }
                    else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
            },
        ),
      ),
    );
  }
}


