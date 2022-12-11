import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(moEditProfile, style: Theme.of(context).textTheme.headline4),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
              const Icon( LineAwesomeIcons.edit)),
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
                child: const Icon(LineAwesomeIcons.camera,
                    size: 20.0, color: Colors.black)),
                  ),
                ],
              ),
            ]
          ),
        ),
      )
    );
  }
}
