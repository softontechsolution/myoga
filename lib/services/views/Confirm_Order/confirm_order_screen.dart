
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';
import '../../controllers/Data_handler/appData.dart';
import '../../models/booking_address_model.dart';
import '../../models/package_details_model.dart';
import '../Payment_Methods/payment_methods_screen.dart';
import '../Select_Ride/select_ride_screen.dart';
import '../User_Dashboard/user_dashboard.dart';

 String pickUpLocation = "";
 String dropOffLocation = "";

class ConfirmOrderScreen extends StatelessWidget {
   ConfirmOrderScreen({Key? key, required this.packageDetails, required this.bookingAddress }) : super(key: key);

  PackageDetails packageDetails;
  BookingAddress bookingAddress;


  @override
  Widget build(BuildContext context) {
    String? placeAddress = Provider.of<AppData>(context, listen: false).pickUpLocation?.placeName;
    pickUpLocation = placeAddress!;
    String? dropPlaceAddress = Provider.of<AppData>(context, listen: false).dropOffLocation?.placeName;
    dropOffLocation = dropPlaceAddress!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text(moConfirmOrderTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Image(
                  image: AssetImage(moPickupPic),
                  height: 16.0,
                  width: 16.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      //borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(moPickupHintText,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      //borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(pickUpLocation,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              children: [
                const Image(
                  image: AssetImage(moPickupPic ),
                  height: 16.0,
                  width: 16.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      //borderRadius: BorderRadius.circular(5.0),
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(moDropOffHintText,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      //borderRadius: BorderRadius.circular(1.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(dropOffLocation,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0,),
            ListTile(
              contentPadding: const EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, color: Colors.grey.shade300)
              ),
              leading: const Image(
                image: AssetImage(moBox),
                height: 60.0,
                width: 60.0,
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(packageDetails.packageType.toString(),),
                    backgroundColor: Colors.deepPurple,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  Text('Weight: ${packageDetails.packageWeight} kg', style: Theme.of(context).textTheme.headline5,),
                  Text('Height: ${packageDetails.packageHeight} cm', style: Theme.of(context).textTheme.headline5,),
                  Text('Width: ${packageDetails.packageWidth} cm', style: Theme.of(context).textTheme.headline5,),
                  Row(
                    children: [
                      OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.purple,
                            padding: const EdgeInsets.all(10),
                          ),
                          child: Text('Payment Method: ${packageDetails.paymentType}', style: Theme.of(context).textTheme.bodyText1,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectRideScreen()),);
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: Text(moProceed.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
