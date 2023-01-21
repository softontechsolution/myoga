import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:myoga/services/models/user_model.dart';
import 'package:myoga/services/views/Profile/profile_screen.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';
import '../../../repositories/authentication_repository/authentication_repository.dart';
import '../../../repositories/user_repository/user_repository.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/signup_controller.dart';
import '../../models/booking_model.dart';
import '../../models/package_details_model.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({Key? key}) : super(key: key);

  final controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title:
          Center(child: Text(moMyOrders, style: Theme.of(context).textTheme.headline4)),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(LineAwesomeIcons.edit)),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),

          ///Future Builder
          child: FutureBuilder<List<BookingModel>>(
            future: controller.getAllUserBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  //Controllers

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (c, index){
                      return  Card(
                        elevation: 2.0,
                          color: moPrimaryColor,
                          child: Column(
                            children: [
                              ListTile(
                                iconColor: moSecondarColor,
                                tileColor: moPrimaryColor,
                                leading: const Icon(LineAwesomeIcons.user, color: moSecondarColor,),
                                trailing: Text(snapshot.data![index].amount!, style: Theme.of(context).textTheme.headline5,),
                                title: Text(snapshot.data![index].status!, style: Theme.of(context).textTheme.headline5,),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data![index].created_at??"", style: Theme.of(context).textTheme.bodyText1,),
                                    const SizedBox(height: 6.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data![index].distance??"", style: Theme.of(context).textTheme.bodyText2,),
                                        const SizedBox(width: 6.0,),
                                        Text(snapshot.data![index].payment_method??"", style: Theme.of(context).textTheme.bodyText2,),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      );
                    },
                  );
                }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
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
            },
          ),
        ));
  }
}
