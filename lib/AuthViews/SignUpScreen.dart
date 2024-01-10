import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:jdx/Models/SignUpModel.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/Views/PrivacyPolicy.dart';
import 'package:jdx/Views/TermsAndConditions.dart';
import '../Controller/BottomNevBar.dart';
import '../CustomWidgets/CustomElevetedButton.dart';
import '../CustomWidgets/CustomTextformfield.dart';
import '../Models/get_city_model.dart';
import '../Models/get_status_model.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../Views/GetHelp.dart';
import '../services/location/location.dart';
import 'AddBankDetails.dart';

File? imageFile;
File? rcFrontFile;
File? rcBackFile;
File? drivingLicenseFile;
File? drivingLicenseBackFile;
File? pancardBackFile;
File? aadharCardFrontFile;
File? aadharCardBackFile;
File? panCardFile;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  singUpModel? information;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController panController = TextEditingController();

  TextEditingController VhicleController = TextEditingController();
  TextEditingController VhicletypeController = TextEditingController();
  TextEditingController LicenceController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController referController = TextEditingController();
  TextEditingController rcController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double? lat;
  double? long;

  getNewSignUp() async {
    var headers = {
      'Cookie': 'ci_session=cd3c13dc5a076f38e4c94afe64948ac08bf8b17c'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/pickport/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': '210',
      'user_phone': '6879889798',
      'user_email': 'test11@gmail.com',
      'vehicle_no': '7',
      'user_password': '12345678',
      'firebaseToken': '4',
      // 'aadhaar_card_no': '6486',
      'vehicle_type': '9+',
      // 'driving_licence_no': '7',
      // 'account_holder_name': '5',
      // 'account_number': '7',
      // 'ifsc_code': '4',
      'user_image': '',
      // 'driving_licence_photo': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
  }

  signUpApi() async {
    var headers = {
      'Cookie': 'ci_session=441db6d062b9f121348edb7be09465992a51c601'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/pickport/api/Authentication/deliveryBoyRegistration'));

    request.fields.addAll({
      'user_fullname': nameController.text,
      'user_email': emailController.text,
      'user_password': passController.text,
      'user_phone': mobController.text,
      'firebaseToken': '4',
      'aadhaar_card_no': aadharController.text,
      'vehicle_type': VhicletypeController.text,
      'vehicle_no': VhicleController.text,
      'driving_licence_no': LicenceController.text,
      'account_holder_name': '5',
      'account_number': '7',
      'ifsc_code': '4',
      'user_image': '',
      'address': addressController.text,
      'lat': '${lat}',
      'lang': '${long}'
    });

    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photo', imageFile?.path ?? ''));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var finalData = json.decode(str);
      Fluttertoast.showToast(msg: "${finalData['message']}");
      setState(() {
        nameController.clear();
        emailController.clear();
        mobController.clear();
        passController.clear();
        VhicleController.clear();
        VhicletypeController.clear();
        LicenceController.clear();
        aadharController.clear();
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print(response.reasonPhrase);
    }
  }

  final ImagePicker _picker = ImagePicker();

  _getFromGallery(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          drivingLicenseFile = File(pickedFile.path);
        });
      } else if (vall == 2) {
        setState(() {
          drivingLicenseBackFile = File(pickedFile.path);
        });
      } else if (vall == 3) {
        setState(() {
          aadharCardFrontFile = File(pickedFile.path);
        });
      } else if (vall == 4) {
        setState(() {
          aadharCardBackFile = File(pickedFile.path);
        });
      } else if (vall == 5) {
        setState(() {
          rcFrontFile = File(pickedFile.path);
        });
      } else if (vall == 6) {
        setState(() {
          rcBackFile = File(pickedFile.path);
        });
      } else if (vall == 7) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else if (vall == 8) {
        setState(() {
          panCardFile = File(pickedFile.path);
        });
      }
      else if (vall == 9) {
        setState(() {
          pancardBackFile = File(pickedFile.path);
        });
      }
    }
  }

  _getCamera(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          drivingLicenseFile = File(pickedFile.path);
        });
      } else if (vall == 2) {
        setState(() {
          drivingLicenseBackFile = File(pickedFile.path);
        });
      } else if (vall == 3) {
        setState(() {
          aadharCardFrontFile = File(pickedFile.path);
        });
      } else if (vall == 4) {
        setState(() {
          aadharCardBackFile = File(pickedFile.path);
        });
      } else if (vall == 5) {
        setState(() {
          rcFrontFile = File(pickedFile.path);
        });
      } else if (vall == 6) {
        setState(() {
          rcBackFile = File(pickedFile.path);
        });
      } else if (vall == 7) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else if (vall == 8) {
        setState(() {
          panCardFile = File(pickedFile.path);
        });
      }
      else if (vall == 9) {
        setState(() {
          pancardBackFile = File(pickedFile.path);
        });
      }
    }
  }

  getSi() async {
    var headers = {
      'Cookie': 'ci_session=321abd54770ce394b6c89c07e2d20a0996c1cff8'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/pickport/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': 'satish',
      'user_phone': '789654130',
      'user_email': 'sa4841@gmail.com',
      'vehicle_no': '7218318',
      'pan_card': 'ASHK54FG',
      'address': 'ujjian',
      'state_id': '9',
      'city_id': '17',
      'user_password': '12345678',
      'refferal_code': '',
      'vehicle_type': '4',
      'vehicle_insurance': '1',
      'pollution_emission': '1',
      'firebaseToken': '',
      'bank_name': 'bob',
      'account_holder_name': 'satish jadav',
      'account_number': '78213891273912738217',
      'ifsc_code': 'BADNAG0iue',
      'account_type': '0'
    });

    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photob',
        '/C:/Users/Alphaiwzz/Downloads/processed-e7661f77-7e06-4a50-ac56-008d3bf25433_g8aYF2Bo (1).jpeg'));
    request.files.add(await http.MultipartFile.fromPath(
        'driving_licence_photof',
        '/C:/Users/Alphaiwzz/Downloads/processed-ea6f5dfc-477c-490e-9a37-e1c4306f4362_0HXCA6xC (1).jpeg'));
    request.files.add(await http.MultipartFile.fromPath('rc_imageb',
        '/C:/Users/Alphaiwzz/Downloads/processed-ea6f5dfc-477c-490e-9a37-e1c4306f4362_0HXCA6xC (1).jpeg'));
    request.files.add(await http.MultipartFile.fromPath('rc_imagef',
        '/C:/Users/Alphaiwzz/Downloads/pickport user gif - Copy.gif'));
    request.files.add(await http.MultipartFile.fromPath('aadhaar_card_photob',
        '/C:/Users/Alphaiwzz/Downloads/processed-7c8aa0c7-fc40-4bc5-b020-0b2db1c232b6_6c3AYSIH.jpeg'));
    request.files.add(await http.MultipartFile.fromPath('aadhaar_card_photof',
        '/C:/Users/Alphaiwzz/Downloads/processed-315cb189-0eca-4558-9d57-ff2abdf2c35d_KrzGnkKR.jpeg'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
  // Future<bool> camGallPopup(int value) async {
  //   return await showDialog(
  //     //show confirm dialogue
  //     //the return value will be from "Yes" or "No" options
  //     context: context,
  //     builder: (context) => AlertDialog(
  //         title:  Center(child: Text('PIC IMAGE',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xFF0F368C)))),
  //         content: Row(
  //           // crossAxisAlignment: CrossAxisAlignment.s,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //                  _getFromGallery(value);
  //                 },
  //                 child: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.black),
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //                     child: const Text('    From Gallery',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color(0xff757575)))),
  //               ),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Expanded(
  //               child: InkWell(
  //                 onTap: () {
  //
  //                 _getCamera(value);
  //                 },
  //                 child: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: colors.primary),
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //
  //                     child: Row(
  //                       children: [
  //
  //                         const Text('   From Camera',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Color(0xff757575))),
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ],
  //         )),
  //   ) ??
  //       false; //if showDialouge had returned null, then return false
  // }

  Future<bool> camGallPopup(int value) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text(
                'Pic Image',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F368C)),
              ),
            ),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromGallery(value);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text('From Gallery',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F368C)))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _getCamera(value);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('From Camera',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F368C))),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ) ??
        false;
  }

  Future<bool> showExitPopupl(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: const Center(
                  child: Text('Upload Driving License',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)))),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        camGallPopup(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text('Driving License Front',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        camGallPopup(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: const [
                              Text('Driving License Back',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff757575),
                                  ),
                              ),
                            ],
                          ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }


  Future<bool> showExitPanCard(int valuef, valueb) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
          title: const Center(
              child: Text('Pan Card',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F368C)))),
          content: Row(
            // crossAxisAlignment: CrossAxisAlignment.s,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    camGallPopup(valuef);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('Pan Card Front',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff757575),),
                      ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    camGallPopup(valueb);
                  },
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: colors.primary),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: const [
                          Text('Pan Card Back',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575),
                              ),
                          ),
                        ],
                      ),
                  ),
                ),
              ),
            ],
          ),
      ),
    ) ?? false;
  }

  Future<bool> showExitPopupa(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
                  child: Text('Upload Aadhar Card',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)))),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text('Aadhar Card Front',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text('Aadhar Card Back',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff757575))),
                            ],
                          )),
                    ),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPopupr(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
                  child: Text('Upload Rc',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F368C)))),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Text('Rc Front',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff757575)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        camGallPopup(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text('Rc Back',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff757575))),
                            ],
                          )),
                    ),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Position? location;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //inIt();
    getStateApi();
  }

  inIt() async {
    location = await getUserCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: colors.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GetHelp() ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: const Text(
                              'Need Help ?',
                              style: TextStyle(color: colors.primary, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Welcome to Pickport',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/Name.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Name",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Name is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          maxLength: 10,
                          controller: mobController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/MOBILE NUMBER.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Mobile Number",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "  Mobile Number is required";
                            }
                            if (v.length != 10) {
                              return "  Mobile Number must be of 10 digit";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/EMAIL ID.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Email Id",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "  Email id is required";
                            }
                            if (!v.contains("@")) {
                              return "  Enter Valid Email Id";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:Colors.white),
                        child: TextFormField(
                          controller: VhicleController,
                          keyboardType: TextInputType.name,
                          maxLength: 10,
                          decoration: InputDecoration(
                            counter: Container(),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/VEHICLE NUMBER.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "  Vehicle Number",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "  Vehicle Number is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            _getFromGallery(7);
                          },
                          // controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/PROFILE PHOTO.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Profile Photo",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Profile Photo is required";
                          //   }
                          // },
                        ),
                      ),
                    ),
                    imageFile != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 115,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: CustomColors.TransparentColor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image:
                                              FileImage(File(imageFile!.path)),
                                          fit: BoxFit.fill)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),

                    // InkWell(
                    //   onTap: () => showExitPopup3(),
                    //   child: Card(
                    //     elevation: 1,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Container(
                    //       height: 115,
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //           color: CustomColors.TransparentColor,
                    //           borderRadius: BorderRadius.circular(10)),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           const Icon(
                    //             Icons.file_copy,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //           const Text(
                    //             'Upload(Profile Photo)*',
                    //             style: TextStyle(color: Colors.red),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           imageFile == null
                    //               ? const SizedBox()
                    //               : Container(
                    //             height: 60,
                    //             width: 200,
                    //             child: ClipRRect(
                    //                 borderRadius:
                    //                 BorderRadius.circular(10),
                    //                 child: Image.file(
                    //                   imageFile ?? File(''),
                    //                   fit: BoxFit.fill,
                    //                 )),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            // camGallPopup(8);
                            showExitPanCard(8, 9);
                          },
                          controller: panController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.location_city,
                                color: CustomColors.accentColor,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Pan Card",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Pan Card is required";
                          //   }
                          // },
                        ),
                      ),
                    ),
                    panCardFile != null
                        ? Row(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                  color: CustomColors.TransparentColor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: FileImage(
                                          File(panCardFile!.path)),
                                      fit: BoxFit.fill),
                              ),
                            ),
                          ),
                        ),
                        pancardBackFile != null
                            ? Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Container(
                              height: 115,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color:
                                  CustomColors.TransparentColor,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: FileImage(File(
                                          pancardBackFile!.path),
                                      ),
                                      fit: BoxFit.fill),
                              ),
                            ),
                          ),
                        ): SizedBox.shrink(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ): SizedBox.shrink(),
                    // Card(
                    //   elevation: 1,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Container(
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: CustomColors.TransparentColor),
                    //     child: TextFormField(
                    //       controller: LicenceController,
                    //       decoration: const InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 10),
                    //           child: Icon(
                    //             Icons.lock,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //         ),
                    //         contentPadding: EdgeInsets.only(top: 22, left: 5),
                    //         border: InputBorder.none,
                    //         hintText: "Driving License",
                    //       ),
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return "  Driving License is required";
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            showExitPopupl(1, 2);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY"
                            //           : "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY",
                            //       onPlacePicked: (result) {
                            //         print(result.formattedAddress);
                            //         setState(() {
                            //           addressController.text =
                            //               result.formattedAddress.toString();
                            //           lat = result.geometry!.location.lat;
                            //           long = result.geometry!.location.lng;
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition: const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //   ),
                            // );
                          },
                          //  controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/DRIVING LICENSE.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Driving License ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Driving License is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    drivingLicenseFile != null
                        ? Row(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(drivingLicenseFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              drivingLicenseBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      drivingLicenseBackFile!
                                                          .path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    // Card(
                    //   elevation: 1,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: CustomColors.TransparentColor),
                    //     child: TextFormField(
                    //       controller: aadharController,
                    //       keyboardType: TextInputType.number,
                    //       maxLength: 12,
                    //       decoration: InputDecoration(
                    //         counter: Container(),
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 10),
                    //           child: Icon(
                    //             Icons.lock,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //         ),
                    //         contentPadding: EdgeInsets.only(top: 22, left: 5),
                    //         border: InputBorder.none,
                    //         hintText: "Aadhar Card ",
                    //       ),
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return "  Aadhar Card is required";
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            showExitPopupa(3, 4);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY"
                            //           : "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY",
                            //       onPlacePicked: (result) {
                            //         print(result.formattedAddress);
                            //         setState(() {
                            //           addressController.text =
                            //               result.formattedAddress.toString();
                            //           lat = result.geometry!.location.lat;
                            //           long = result.geometry!.location.lng;
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition: const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //   ),
                            // );
                          },
                          //    controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/AADHAR CARD.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Aadhar Card ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Aadhar Card  is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    aadharCardFrontFile != null
                        ? Row(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                aadharCardFrontFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              aadharCardBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(File(
                                                      aadharCardBackFile!
                                                          .path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),

                    const SizedBox(
                      height: 5,
                    ),
                    // Card(
                    //   elevation: 1,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: Container(
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: CustomColors.TransparentColor),
                    //     child: TextFormField(
                    //       controller: rcController,
                    //       decoration: const InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(top: 10),
                    //           child: Icon(
                    //             Icons.lock,
                    //             color: CustomColors.accentColor,
                    //           ),
                    //         ),
                    //         contentPadding: EdgeInsets.only(top: 22, left: 5),
                    //         border: InputBorder.none,
                    //         hintText: "RC",
                    //       ),
                    //       validator: (v) {
                    //         if (v!.isEmpty) {
                    //           return "  RC is required";
                    //         }
                    //       },
                    //     ),
                    //   ),
                    // ),

                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          readOnly: true,
                          maxLength: 10,
                          onTap: () {
                            showExitPopupr(5, 6);
                            // showExitPopup(3);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PlacePicker(
                            //       apiKey: Platform.isAndroid
                            //           ? "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY"
                            //           : "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY",
                            //       onPlacePicked: (result) {
                            //         print(result.formattedAddress);
                            //         setState(() {
                            //           addressController.text =
                            //               result.formattedAddress.toString();
                            //           lat = result.geometry!.location.lat;
                            //           long = result.geometry!.location.lng;
                            //         });
                            //         Navigator.of(context).pop();
                            //       },
                            //       initialPosition: const LatLng(22.719568, 75.857727),
                            //       useCurrentLocation: true,
                            //     ),
                            //   ),
                            // );
                          },
                          //  controller: addressController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/RC.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "RC ",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "RC is required";
                          //   }
                          // },
                        ),
                      ),
                    ),

                    rcFrontFile != null
                        ? Row(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 115,
                                    decoration: BoxDecoration(
                                        color: CustomColors.TransparentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File(rcFrontFile!.path)),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              ),
                              rcBackFile != null
                                  ? Expanded(
                                      child: Card(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 115,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color:
                                                  CustomColors.TransparentColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      File(rcBackFile!.path)),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 10),
                              prefixIcon: Image.asset(
                                'assets/images/ADDRESS.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                              hintText: "Address",
                              border: InputBorder.none),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  apiKey: Platform.isAndroid
                                      ? "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY"
                                      : "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY",
                                  onPlacePicked: (result) {
                                    print(result.formattedAddress);
                                    setState(() {
                                      addressController.text =
                                          result.formattedAddress.toString();
                                      lat = result.geometry!.location.lat;
                                      long = result.geometry!.location.lng;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  initialPosition:
                                      const LatLng(22.719568, 75.857727),
                                  useCurrentLocation: true,
                                ),
                              ),
                            );
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "  Address is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      elevation: 1,
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Icon(
                                      Icons.location_city,
                                      color: CustomColors.accentColor,
                                    ),
                                  )),
                              Expanded(
                                flex: 10,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<GetCityList>(
                                    isExpanded: true,
                                    //hint:  Text(getTranslated(context, "State"),
                                    hint: const Text(
                                      "State",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                    value: getCityList,

                                    // icon:  Icon(Icons.keyboard_arrow_down_rounded,  color:Secondry,size: 25,),
                                    style: const TextStyle(
                                        color: colors.secondary,
                                        fontWeight: FontWeight.bold),
                                    underline: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 4),
                                      child: Container(
                                        // height: 2,
                                        color: colors.whiteTemp,
                                      ),
                                    ),
                                    onChanged: (GetCityList? value) {
                                      setState(() {
                                        getCityList = value!;
                                        stateId = getCityList?.stateId;
                                        getCityApi(stateId!);
                                        //animalCountApi(animalCat!.id);
                                      });
                                    },
                                    items: getStatusModel?.data?.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Text(
                                                  items.stateName.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      elevation: 1,
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 13),
                                    child: Icon(
                                      Icons.location_city,
                                      color: CustomColors.accentColor,
                                    ),
                                  )),
                              Expanded(
                                flex: 10,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<GetStateList>(
                                    isExpanded: true,
                                    //hint:  Text(getTranslated(context, "City"),
                                    hint: const Text(
                                      "City",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                    value: getStateList,

                                    // icon:  Icon(Icons.keyboard_arrow_down_rounded,  color:Secondry,size: 25,),
                                    style: const TextStyle(
                                        color: colors.secondary,
                                        fontWeight: FontWeight.bold),
                                    underline: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 4),
                                      child: Container(
                                        // height: 2,
                                        color: colors.whiteTemp,
                                      ),
                                    ),
                                    onChanged: (GetStateList? value) {
                                      setState(() {
                                        getStateList = value!;
                                        cityId = getStateList?.cityId;
                                        //animalCountApi(animalCat!.id);
                                      });
                                    },
                                    items: getCityModel?.data?.map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0),
                                                child: Text(
                                                  items.cityName.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          obscureText: !isVisible,
                          controller: passController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 8),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            // hintText: getTranslated(context, "Password"),
                            hintText: "Password",
                            prefixIcon: Image.asset(
                              'assets/images/Icon ionic-ios-lock.png',
                              scale: 1.3,
                              color: colors.secondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible
                                      ? isVisible = false
                                      : isVisible = true;
                                });
                              },
                              icon: Icon(
                                isVisible
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "  Password is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          obscureText: !isVisible1,
                          controller: cPassController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 8),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Confirm Password",
                            prefixIcon: Image.asset(
                              'assets/images/Icon ionic-ios-lock.png',
                              scale: 1.3,
                              color: colors.secondary,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible1
                                      ? isVisible1 = false
                                      : isVisible1 = true;
                                });
                              },
                              icon: Icon(
                                isVisible1
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '  Please confirm your password';
                            } else if (value != passController.text) {
                              return '  Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: TextFormField(
                          controller: referController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image.asset(
                                'assets/images/REFERAL ODE.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Referral Code (Optional)",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Vehicle type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 1;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 1
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      '2 Wheeler Gear',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 6;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 6
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Text(
                                      '2 Wheeler Non Gear',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 5;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 5
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'Mahindra Pickup',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 4;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 4
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'Tata 407',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 3;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 3
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      '3 Wheeler',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selected = 2;
                                });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == 2
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off_outlined,
                                      color: colors.secondary,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'Tata Ace',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Insurance",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => colors.secondary),
                          activeColor: colors.secondary,
                          groupValue: _value,
                          onChanged: (int? value) {
                            setState(() {
                              _value = value!;
                              isNonAvailable = false;
                            });
                          },
                        ),
                        Text(
                          "Yes",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Radio(
                            value: 1,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => colors.secondary),
                            activeColor: colors.secondary,
                            groupValue: _value,
                            onChanged: (int? value) {
                              setState(() {
                                _value = value!;
                                isAvailable = true;
                              });
                            }),
                        // SizedBox(width: 10.0,),
                        Text(
                          "No",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Pollution Emission",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => colors.secondary),
                          activeColor: colors.secondary,
                          groupValue: _value1,
                          onChanged: (int? value) {
                            setState(() {
                              _value1 = value!;
                              isNonAvailable1 = false;
                            });
                          },
                        ),
                        Text(
                          "Yes",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Radio(
                            value: 1,
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => colors.secondary),
                            activeColor: colors.secondary,
                            groupValue: _value1,
                            onChanged: (int? value) {
                              setState(() {
                                _value1 = value!;
                                isAvailable1 = true;
                              });
                            }),
                        // SizedBox(width: 10.0,),
                        Text(
                          "No",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),

                    // selected == 0
                    //     ?
                    Container(
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isTerm = !isTerm;
                            });
                          },
                          child: Icon(
                            isTerm
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'I agree to all ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsConditionsWidget()));
                          },
                          // onTap: () {

                          //   //Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionScreen()));
                          // },
                          child: Text(
                            "T&C",
                            // getTranslated(context, "Terms and Conditions"),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '& ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => privacy_policy()));
                          },
                          child: Text(
                            // getTranslated(context, "Privacy Policy"),
                            "Privacy Policy",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.primary),
                          ),
                        ),
                      ]),
                    ),
                    // : Container(),

                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddBankDetails(
                                        mobile: mobController.text,
                                        name: nameController.text,
                                        address: addressController.text,
                                        adhar: aadharController.text,
                                        cPass: cPassController.text,
                                        email: emailController.text,
                                        Licence: LicenceController.text,
                                        pan: panController.text,
                                        pass: passController.text,
                                        rc: rcController.text,
                                        refer: referController.text,
                                        vcNo: VhicleController.text,
                                        lat: lat,
                                        long: long,
                                        image: imageFile!.path.toString(),
                                        sId: stateId.toString(),
                                        cID: cityId.toString(),
                                        Insurance: _value.toString(),
                                        pollution: _value1.toString(),
                                        vType: selected.toString(),
                                      ),
                              ),
                            );
                          } else if (isTerm == false) {
                            Fluttertoast.showToast(msg: "I agree to all ");
                          } else {
                            Fluttertoast.showToast(
                                msg: "All field are required");
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 290,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Row(
                          children: [
                            const Text('Already have an Account?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(color: colors.secondary),
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? stateId;
  GetCityList? getCityList;
  GetStatusModel? getStatusModel;
  getStateApi() async {
    var headers = {
      'Cookie': 'ci_session=72caa85cedaa1a0d8ccc629445189f73af6a9946'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/api_get_state'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetStatusModel.fromJson(json.decode(result));
      setState(() {
        getStatusModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  bool isLoading = false;
  String? cityId;
  GetStateList? getStateList;
  GetCityModel? getCityModel;

  getCityApi(String stateId) async {
    setState(() {
      isLoading = true;
    });
    var headers = {
      'Cookie': 'ci_session=c59791396657a1155df9f32cc7d7b547a40d648c'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/api_get_city'));
    request.fields.addAll({'state_id': stateId.toString()});

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetCityModel.fromJson(json.decode(result));
      setState(() {
        getCityModel = finalResult;
      });
      setState(() {
        // Fluttertoast.showToast(msg: "${finalResult['message']}");
      });
    } else {
      setState(() {
        setState(() {
          isLoading = false;
        });
      });
      print(response.reasonPhrase);
    }
  }

  bool isVisible = false;
  bool isVisible1 = false;
  bool isTerm = false;
  int selected = 1;

  int _value = 0;
  bool isNonAvailable = false;
  bool isAvailable = false;

  int _value1 = 0;
  bool isNonAvailable1 = false;
  bool isAvailable1 = false;
}
