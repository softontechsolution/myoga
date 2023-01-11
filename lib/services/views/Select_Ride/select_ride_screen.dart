import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
import '../Dashboard/widget/appbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Pickup_Location/pickup_location_screen.dart';


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


  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 300.0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainer = 300.0;
  double ridePriceContainer = 0;

  bool drawerOpen = true;

  void displayRideDetailsContainer() async {
   await getPlaceDirection();

   setState(() {
    rideDetailsContainer = 0;
    ridePriceContainer = 380.0;
    bottomPaddingOfMap = 380.0;
   });
 }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistanceMethods.searchCoordinateAddress(position, context);

  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    getPlaceDirection();
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
                            onPressed: (){},
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


          // Container(
          // decoration: const BoxDecoration(
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
          //   color: Colors.white,
          // ),
          // height: 250.0,
          // child: Column(
          //  children: [
          //    SizedBox(height: 12.0,),
          //  ],
          // ),
          //),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PButtonColor,
        elevation: 10.0,
        child: const Icon(LineAwesomeIcons.times,
            color: Colors.white,
            size: 3.0),
      ),
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
