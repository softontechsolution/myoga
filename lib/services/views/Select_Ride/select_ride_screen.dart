import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myoga/configMaps.dart';
import 'package:myoga/services/controllers/Data_handler/appData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/texts_string.dart';
import '../../../widgets/progressDialog.dart';
import '../../controllers/Assistant/assistanceMethods.dart';
import '../../controllers/user_dashboard_controller.dart';
import '../../models/directDetails.dart';
import '../../models/package_details_model.dart';
import '../Dashboard/widget/appbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Pickup_Location/pickup_location_screen.dart';
import '../User_Dashboard/user_dashboard.dart';


class SelectRideScreen extends StatefulWidget {


  const SelectRideScreen({super.key});

  @override
  State<SelectRideScreen> createState() => _SelectRideScreenState();
}



class _SelectRideScreenState extends State<SelectRideScreen> with TickerProviderStateMixin
{
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

  late DirectionDetails tripDirectionDetails;
  String pickUpLocation = "";
  String dropOffLocation = "";
  late PackageDetails packageDetails;


  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 300.0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainer = 300.0;
  double requestDriverContainer = 0;
  double ridePriceContainer = 0;

  bool drawerOpen = true;
  late DatabaseReference bookingRequestReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistanceMethods.getCurrentOnlineUserInfo();
  }

  void saveBookingRequest()
  {
    bookingRequestReference = FirebaseDatabase.instance.ref().child('Booking Request').push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap =
    {
          "latitude": pickUp?.latitude.toString(),
          "longitude": pickUp?.longitude.toString(),
    };
    Map dropOffLocMap =
    {
      "latitude": dropOff?.latitude.toString(),
      "longitude": dropOff?.longitude.toString(),
    };
    Map bookingInfoMap =
    {
      "driver_id": "waiting",
      "payment_method": packageDetails.paymentType,
      "pickup": pickUpLocMap,
      "drop_off": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "customer_name": userCurrentInfo.name,
      "customer_phone": userCurrentInfo.phone,
      "customer_id": userCurrentInfo.id,
      "pickup_address": pickUp?.placeName,
      "dropoff_address": dropOff?.placeName,
      "status": "pending",
    };
    bookingRequestReference.set(bookingInfoMap);
  }

  void cancelBookingRequest(){
    bookingRequestReference.remove();
  }

  void displayRequestDriverContainer(){
    setState(() {
      requestDriverContainer = 380.0;
      ridePriceContainer = 0;
      rideDetailsContainer = 0;
      bottomPaddingOfMap = 380.0;
      drawerOpen = false;
    });
    saveBookingRequest();
  }

  resetApp(){
    setState(() {
      drawerOpen = true;
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
      Get.offAll(() => const UserDashboard());
    });
  }

  void displayRideDetailsContainer() async {
   await getPlaceDirection();

   setState(() {
    rideDetailsContainer = 0;
    ridePriceContainer = 380.0;
    bottomPaddingOfMap = 380.0;
    drawerOpen = false;
   });
 }

  void locatePosition() async {
    ///Asking Users Permission
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    setState(() {
      getPlaceDirection();
    });
    String? placeAddress = Provider.of<AppData>(context, listen: false).pickUpLocation?.placeName;
    pickUpLocation = placeAddress!;
    String? dropPlaceAddress = Provider.of<AppData>(context, listen: false).dropOffLocation?.placeName;
    dropOffLocation = dropPlaceAddress!;
    return Scaffold(
      appBar: const DashboardAppBar(),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();

            },
          ),
          //Hamburger Drawer
          //Ride Container Details
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              // ignore: deprecated_member_use
              vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainer,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0),),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Text("Select Ride", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center,),
                      const SizedBox(width: 10.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Image(image: AssetImage(moCar), height: 70.0, width: 70.0,),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Car", style: Theme.of(context).textTheme.headline4,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Image(image: AssetImage(moMotor), height: 70.0, width: 70.0,),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Motorcycle", style: Theme.of(context).textTheme.headline4,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){ displayRideDetailsContainer(); },
                            child: Text(moProceed.toUpperCase(), style: const TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //Price Container Details
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              // ignore: deprecated_member_use
              vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: ridePriceContainer,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0),),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Text("Select Delivery Mode", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center,),
                      const SizedBox(width: 10.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Image(image: AssetImage(moCar), height: 70.0, width: 70.0,),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(moExpress, style: Theme.of(context).textTheme.headline4,),
                                  Text(moExpressDays, style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tripDirectionDetails.distanceText!, style: Theme.of(context).textTheme.headline4,),
                                  Text(((tripDirectionDetails != null) ? "\N${AssistanceMethods.calculateFares(tripDirectionDetails)}" : "" ), style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Image(image: AssetImage(moCar), height: 70.0, width: 70.0,),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(moStandard, style: Theme.of(context).textTheme.headline4,),
                                  Text(moStandardDays, style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(((tripDirectionDetails != null) ? tripDirectionDetails.distanceText! : ""), style: Theme.of(context).textTheme.headline4,),
                                  Text(((tripDirectionDetails != null) ? "\N${AssistanceMethods.calculateFares(tripDirectionDetails)}" : "" ), style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Container(
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              const Image(image: AssetImage(moCar), height: 70.0, width: 70.0,),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(moNormal, style: Theme.of(context).textTheme.headline4,),
                                  Text(moNormalDays, style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                              const SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tripDirectionDetails.distanceText!, style: Theme.of(context).textTheme.headline4,),
                                  Text(((tripDirectionDetails != null) ? "\N${AssistanceMethods.calculateFares(tripDirectionDetails)}" : "" ), style: Theme.of(context).textTheme.bodyText2,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){
                              displayRequestDriverContainer();
                            },
                            child: Text(moProceed.toUpperCase(), style: const TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                color: Colors.white,
              ),
              height: requestDriverContainer,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text("Order Placed", style: Theme.of(context).textTheme.bodyText1,),
                    const SizedBox(height: 12.0,),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'Booking Request Processing....',
                            textStyle: colorizeTextStyle, textAlign: TextAlign.center,
                            colors: colorizeColors,
                          ),
                          ColorizeAnimatedText(
                            'Please Wait....',
                            textStyle: colorizeTextStyle, textAlign: TextAlign.center,
                            colors: colorizeColors,
                          ),
                          ColorizeAnimatedText(
                            'Looking for your captain..',
                            textStyle: colorizeTextStyle, textAlign: TextAlign.center,
                            colors: colorizeColors,
                          ),
                        ],
                        isRepeatingAnimation: true,
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                    const SizedBox(height: 12.0,),
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
                    const SizedBox(height: 12.0,),
                    Text("Distance: ${tripDirectionDetails.distanceText}", style: Theme.of(context).textTheme.bodyText2,),
                    Text("Duration: ${tripDirectionDetails.durationText}", style: Theme.of(context).textTheme.bodyText2,),
                    const SizedBox(height: 12.0,),
                    GestureDetector(
                      onTap: (){
                        cancelBookingRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(width: 2.0, color: Colors.purple.shade50,)
                        ),
                        child: const Icon(Icons.close, size: 20.0,),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    SizedBox(
                      width: double.infinity,
                      child: Text("Cancel Booking", style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: DraggableFab(
          child: FloatingActionButton(
            onPressed: () {
              resetApp();
              },
        backgroundColor: PButtonColor,
        elevation: 10.0,
        child: const Icon(LineAwesomeIcons.times,
            color: Colors.white,
            size: 28.0),
      )),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatlng = LatLng(initialPos!.latitude!, initialPos.longitude!);
    var dropOffLatlng = LatLng(finalPos!.latitude!, finalPos.longitude!);

    var details = await AssistanceMethods.obtainPlaceDirectionDetails(pickUpLatlng, dropOffLatlng);
    setState(() {
      tripDirectionDetails = details!;
    });


    print("THIS IS THE ENCODED POINTS");
    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details.encodedPoints ?? "");

    pLineCoordinates.clear();

    if(decodedPolylinePointsResult.isNotEmpty){
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.cast();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatlng.latitude > dropOffLatlng.latitude && pickUpLatlng.longitude > dropOffLatlng.longitude){
      latLngBounds = LatLngBounds(southwest: dropOffLatlng, northeast: pickUpLatlng);
    }
    else if(pickUpLatlng.longitude > dropOffLatlng.longitude){
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatlng.latitude, dropOffLatlng.longitude), northeast: LatLng(dropOffLatlng.latitude, pickUpLatlng.longitude));
    }
    else if(pickUpLatlng.latitude > dropOffLatlng.latitude){
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatlng.latitude, pickUpLatlng.longitude), northeast: LatLng(pickUpLatlng.latitude, dropOffLatlng.longitude));
    }
    else {
      latLngBounds = LatLngBounds(southwest: pickUpLatlng, northeast: dropOffLatlng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUpLatlng,
      markerId: const MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatlng,
      markerId: const MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: const CircleId("pickUpId"),

    );
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: const CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}
