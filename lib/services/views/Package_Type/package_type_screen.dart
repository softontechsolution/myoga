import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../constants/texts_string.dart';
import '../../models/booking_address_model.dart';
import '../../models/package_details_model.dart';
import '../Confirm_Order/confirm_order_screen.dart';

enum PackageTypeEnum { Container, Box, Others }

class PackageTypeScreen extends StatefulWidget {
  const PackageTypeScreen({Key? key}) : super(key: key);

  @override
  State<PackageTypeScreen> createState() => _PackageTypeScreenState();
}

class _PackageTypeScreenState extends State<PackageTypeScreen> {
  _PackageTypeScreenState() {
    _selectedVal = _paymentMethodList[0];
  }

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  PackageTypeEnum? _packageTypeEnum;

  final _paymentMethodList = ["Cash on Delivery", "Wallet", "Bank"];
  String? _selectedVal = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text(moPackageTitle),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              moPackageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              moPackageDetailsForm,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(
              height: 30.0,
            ),


            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter weight in kg";
                      }
                      else {
                        return null;
                      }
                    },
                    controller: _weightController,
                    decoration: const InputDecoration(
                      label: Text(moWeight),
                      prefixIcon:
                      Icon(LineAwesomeIcons.balance_scale__left_weighted_),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter height in cm";
                      }
                      else {
                        return null;
                      }
                    },
                    controller: _heightController,
                    decoration: const InputDecoration(
                      label: Text(moHeight),
                      prefixIcon: Icon(LineAwesomeIcons.ruler_vertical),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter width in cm";
                      }
                      else {
                        return null;
                      }
                    },
                    controller: _widthController,
                    decoration: const InputDecoration(
                      label: Text(moWidth),
                      prefixIcon: Icon(LineAwesomeIcons.ruler_horizontal),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    moSelectPackageType,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<PackageTypeEnum>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: PackageTypeEnum.Container,
                          groupValue: _packageTypeEnum,
                          dense: true,
                          tileColor: Colors.deepPurple.shade50,
                          title: Text(PackageTypeEnum.Container.name),
                          onChanged: (val) {
                            setState(() {
                              _packageTypeEnum = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RadioListTile<PackageTypeEnum>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: PackageTypeEnum.Box,
                          groupValue: _packageTypeEnum,
                          dense: true,
                          tileColor: Colors.deepPurple.shade50,
                          title: Text(PackageTypeEnum.Box.name),
                          onChanged: (val) {
                            setState(() {
                              _packageTypeEnum = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RadioListTile<PackageTypeEnum>(
                          contentPadding: const EdgeInsets.all(0.0),
                          value: PackageTypeEnum.Others,
                          groupValue: _packageTypeEnum,
                          dense: true,
                          tileColor: Colors.deepPurple.shade50,
                          title: Text(PackageTypeEnum.Others.name),
                          onChanged: (val) {
                            setState(() {
                              _packageTypeEnum = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DropdownButtonFormField(
                    value: _selectedVal,
                    items: _paymentMethodList
                        .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedVal = val as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.deepPurple,
                    ),
                    dropdownColor: Colors.deepPurple.shade50,
                    decoration: const InputDecoration(
                      labelText: "Select Payment Method",
                      prefixIcon: Icon(
                        Icons.wallet,
                        color: Colors.deepPurple,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          BookingAddress bookingAddress = BookingAddress();
                          PackageDetails packageDetails = PackageDetails();
                          packageDetails.packageWeight = _weightController.text;
                          packageDetails.packageHeight = _heightController.text;
                          packageDetails.packageWidth = _widthController.text;
                          packageDetails.packageType = _packageTypeEnum!;
                          packageDetails.paymentType = _selectedVal!;

                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ConfirmOrderScreen(packageDetails: packageDetails, bookingAddress: bookingAddress,);
                          }));

                        }
                      },
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: Text(moProceed.toUpperCase()),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
