import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:myoga/services/views/Profile/update_profile_screen.dart';
import 'package:myoga/services/models/user_model.dart';
import 'package:myoga/services/views/Profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/profile_photo_controller.dart';

import '../../../constants/colors.dart';
import '../../../constants/texts_string.dart';
import '../../../constants/image_strings.dart';
import '../Forget_Password/Change Password/change_password.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({Key? key}) : super(key: key);

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {

  final _controller = Get.put(ProfileController());


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
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
      body: ChangeNotifierProvider(
        create: (_) => ProfilePhotoController(),
        child: Consumer<ProfilePhotoController>(
          builder: (context, provider, child){
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                  future: _controller.getUserData(),
                  builder: (context,  snapshot) {
                    if (snapshot.connectionState == ConnectionState.done){
                      if (snapshot.hasData){
                        UserModel userData = snapshot.data as UserModel;
                        return Column(
                          children: [
                            const SizedBox(height: 20),
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
                                      ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Text(moProfilePics, style: Theme.of(context).textTheme.headline4),
                            const SizedBox(height: 15.0),
                            const Divider(),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(moProfileInfoHead, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20.0,),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(moProfileName, style: Theme.of(context).textTheme.headline5,),
                                    Text(userData.fullname == null ? "Complete profile" : userData.fullname!, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(moProfileEmail, style: Theme.of(context).textTheme.headline5,),
                                    Text(userData.email == null ? "Complete profile" : userData.email!, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(moProfilePhone, style: Theme.of(context).textTheme.headline5,),
                                    Text(userData.phoneNo == null ? "Complete profile" : userData.phoneNo!,  style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(moProfileAddress, style: Theme.of(context).textTheme.headline5,),
                                    Text( userData.address == null ? "Complete profile" : userData.address!, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Date of Birth", style: Theme.of(context).textTheme.headline5,),
                                    Text( userData.dateOfBirth == null ? "Complete profile" : userData.dateOfBirth!, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Gender", style: Theme.of(context).textTheme.headline5,),
                                    Text( userData.gender == null ? "Complete profile" : userData.gender!, style: Theme.of(context).textTheme.bodyText1,),
                                  ],
                                ),
                                const SizedBox(height: 30.0,),
                                const Divider(),
                                const SizedBox(height: 30.0,),
                                TextButton(onPressed: (){
                                  Get.to(()=> const ChangePasswordScreen());
                                },
                                    child: const Text("Change Password", style: TextStyle(color: moAccentColor,fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                    )
                                ),
                              ],
                            )
                          ],
                        );
                      }
                      else if (snapshot.hasError) {
                        return Center(
                          child: Text("Profile incomplete: click here to complete profile"),
                        );
                      }
                      else {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                    }
                    else {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                  }
                ),
              ),
            );
          }
        )
      ),
    );
  }
}
