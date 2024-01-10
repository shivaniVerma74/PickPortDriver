import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/Utils/Color.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:jdx/Views/EditProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomWidgets/CustomElevetedButton.dart';
import '../Models/GetProfileModel.dart';
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
import '../Controller/BottomNevBar.dart';
import '../CustomWidgets/CustomElevetedButton.dart';
import '../CustomWidgets/CustomTextformfield.dart';
import '../Models/get_city_model.dart';
import '../Models/get_status_model.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../services/api_services/request_key.dart';
import '../services/location/location.dart';

class Myprofile extends StatefulWidget {
  GetProfileModel? getProfileModel;
  Myprofile({this.getProfileModel});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
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

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  double? lat;
  double? long;
  //File? imageFile;
  File? rcFrontFile;
  File? rcBackFile;
  File? drivingLicenseFile;
  File? drivingLicenseBackFile;
  File? aadharCardFrontFile;
  File? aadharCardBackFile;
  var getprofile;
  var rcf;
  var rcb;
  var adhf;
  var adhb;
  var dlf;
  var dlb;
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
      }
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  bool isLoading = false;
  String? cityId;
  GetStateList? getStateList;
  GetCityModel? getCityModel;
  dynamic stateidstring;
  dynamic cityidstring;
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

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: const Text('Select Image'),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getFromCamera();
                    },
                    //return false when click on "NO"
                    child: const Text('Camera'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getFromGallery(7);
                      // Navigator.pop(context,true);
                      // Navigator.pop(context,true);
                    },
                    //return true when click on "Yes"
                    child: const Text('Gallery'),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showExitPopupl(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
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
                        _getFromGallery(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
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
                        _getFromGallery(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text('Driving License Back',
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

  Future<bool> showExitPopupa(int valuef, valueb) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Center(
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
                        _getFromGallery(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
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
                        _getFromGallery(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text('Driving License Back',
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
                        _getFromGallery(valuef);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
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
                        _getFromGallery(valueb);
                      },
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: colors.primary),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              const Text('Driving License Back',
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

  @override
  void initState() {
    // TODO: implement initState
    nameController.text =
        widget.getProfileModel!.data![0].userFullname.toString();
    emailController.text =
        widget.getProfileModel!.data![0].userEmail.toString();
    mobController.text = widget.getProfileModel!.data![0].userPhone.toString();

    VhicleController.text =
        widget.getProfileModel!.data![0].vehicleNo.toString();
    VhicletypeController.text =
        widget.getProfileModel!.data![0].vehicleType.toString();
    LicenceController.text =
        widget.getProfileModel!.data![0].drivingLicenceNo.toString();
    aadharController.text =
        widget.getProfileModel!.data![0].aadhaarCardNo.toString();
    panController.text = widget.getProfileModel!.data![0].panCard.toString();

    getprofile = widget.getProfileModel!.data![0].userImage.toString();
    rcf = widget.getProfileModel!.data![0].rcImagef.toString();
    rcb = widget.getProfileModel!.data![0].rcImageb.toString();
    adhf = widget.getProfileModel!.data![0].aadhaarCardPhotof.toString();
    adhb = widget.getProfileModel!.data![0].aadhaarCardPhotob.toString();
    dlf = "https://developmentalphawizz.com/pickport/api/uploads/profile/" +
        widget.getProfileModel!.data![0].drivingLicencePhotof.toString();
    dlb = "https://developmentalphawizz.com/pickport/api/uploads/profile/" +
        widget.getProfileModel!.data![0].drivingLicencePhotob.toString();
    print(dlf.toString() + "lllllllllll");
    // cityId = widget.getProfileModel!.data![0].cityName.toString();
    // stateId = widget.getProfileModel!.data![0].stateName.toString();
    selected =
        int.parse(widget.getProfileModel!.data![0].vehicleType.toString());
    _value =
        int.parse(widget.getProfileModel!.data![0].vehicleInsurance.toString());
    _value1 = int.parse(
        widget.getProfileModel!.data![0].pollutionEmission.toString());
    setState(() {});
    // print('____Som______${widget.getProfileModel!.data![0].stateName.toString()}_________');
    // stateidstring=getStatusModel?.data?.firstWhere((item) => item.stateName.toString().trim().toLowerCase() == widget.getProfileModel!.data![0].stateName.toString().trim().toLowerCase());

    getStateApi();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // print('${widget.getProfileModel!.data![0].drivingLicencePhoto}____');
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        title: Container(
            padding: const EdgeInsets.all(2),
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  height: 40,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 60,
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.person,
                                    color: CustomColors.accentColor,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 5),
                                border: InputBorder.none,
                                hintText: "Name",
                                label: Text(
                                  'Name',
                                  style: TextStyle(color: Colors.black),
                                )),
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            maxLength: 10,
                            controller: mobController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                counterText: "",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.call,
                                    color: CustomColors.accentColor,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 5),
                                border: InputBorder.none,
                                hintText: "Mobile Number",
                                label: Text(
                                  'Mobile Number',
                                  style: TextStyle(color: Colors.black),
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Mobile Number is required";
                              }
                              if (v.length != 10) {
                                return "Mobile Number must be of 10 digit";
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.email,
                                    color: CustomColors.accentColor,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 5),
                                border: InputBorder.none,
                                hintText: "Email Id",
                                label: Text(
                                  'Email Id',
                                  style: TextStyle(color: Colors.black),
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Email id is required";
                              }
                              if (!v.contains("@")) {
                                return "Enter Valid Email Id";
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            controller: VhicleController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.card_giftcard_outlined,
                                    color: CustomColors.accentColor,
                                  ),
                                ),
                                contentPadding:
                                    EdgeInsets.only(top: 15, left: 5),
                                border: InputBorder.none,
                                hintText: "Vehicle number",
                                label: Text(
                                  'Vehicle Number',
                                  style: TextStyle(color: Colors.black),
                                )),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Vehicle Number is required";
                              }
                            },
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // InkWell(
                      //   onTap: () => showExitPopup(),
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
                      //                   height: 60,
                      //                   width: 200,
                      //                   child: ClipRRect(
                      //                       borderRadius:
                      //                           BorderRadius.circular(10),
                      //                       child: Image.file(
                      //                         imageFile ?? File(''),
                      //                         fit: BoxFit.fill,
                      //                       )),
                      //                 ),
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            controller: panController,
                            decoration: const InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(
                                  Icons.lock,
                                  color: CustomColors.accentColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 22, left: 5),
                              border: InputBorder.none,
                              hintText: "Pan Card",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Pan Card is required";
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            maxLength: 10,
                            onTap: () {
                              // showExitPopupl(1, 2);
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
                              hintText: "Driving License ",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Driving License is required";
                              }
                            },
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 115,
                                      decoration: BoxDecoration(
                                          color: CustomColors.TransparentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image: FileImage(File(
                                                  drivingLicenseFile!.path)),
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
                                                color: CustomColors
                                                    .TransparentColor,
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
                          : Row(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 115,
                                      decoration: BoxDecoration(
                                          color: CustomColors.TransparentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(dlf.toString()),
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
                                                color: CustomColors
                                                    .TransparentColor,
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
                                    : Expanded(
                                        child: Card(
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: 115,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: CustomColors
                                                    .TransparentColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        dlb.toString()),
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),

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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            maxLength: 10,
                            onTap: () {
                              // showExitPopupa(3, 4);
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
                              hintText: "Aadhar Card ",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Aadhar Card  is required";
                              }
                            },
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 115,
                                      decoration: BoxDecoration(
                                          color: CustomColors.TransparentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                color: CustomColors
                                                    .TransparentColor,
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            maxLength: 10,
                            onTap: () {
                              // showExitPopupr(5, 6);
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
                              hintText: "RC ",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "RC is required";
                              }
                            },
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 115,
                                      decoration: BoxDecoration(
                                          color: CustomColors.TransparentColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                color: CustomColors
                                                    .TransparentColor,
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
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            readOnly: true,
                            controller: addressController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 10),
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: colors.secondary,
                                ),
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
                                return "Address is required";
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                                color: CustomColors.TransparentColor),
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
                                    child: DropdownButton2<dynamic>(
                                      isExpanded: true,
                                      //hint:  Text(getTranslated(context, "State"),
                                      hint: const Text(
                                        "State",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      value: stateidstring,
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
                                      onChanged: (value) {
                                        setState(() {
                                          stateidstring = value!;
                                          //  stateId = getCityList?.stateId;
                                          getCityApi(value.stateId!);
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
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    items.stateName.toString(),
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
                        elevation: 1,
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: CustomColors.TransparentColor),
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
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      value: cityidstring,

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
                                      onChanged: (value) {
                                        setState(() {
                                          cityidstring = value!;
                                          // cityId = getStateList?.cityId;
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
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Container(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
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
                                        '2 Wheeler',
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
                              const SizedBox(
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
                                          fontSize: 12,
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
                                          fontSize: 12,
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
                                        width: 5,
                                      ),
                                      const Text(
                                        '2 wheeler Non Gea',
                                        style: TextStyle(
                                          fontSize: 12,
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
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                          onTap: () {
                            _updateProfile();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: isLodding == true
                                    ? Center(child: CircularProgressIndicator())
                                    : Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () => showExitPopup(),
                  child: Container(
                      alignment: Alignment.topCenter,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: imageFile == null
                          ? (widget.getProfileModel!.data![0].userImage ==
                                      null ||
                                  widget.getProfileModel!.data![0].userImage ==
                                      "")
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    "assets/images/profileImage.jpg",
                                    fit: BoxFit.fill,
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            "${widget.getProfileModel!.data![0].userImage}",
                                          ),
                                          fit: BoxFit.fill)),
                                )

                          //  ClipRRect(
                          // borderRadius: BorderRadius.circular(100),
                          // child: Image.network(
                          //   "${widget.getProfileModel!.data![0].userImage}",
                          //   fit: BoxFit.fill,
                          // ))
                          : Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(
                                        imageFile ?? File(''),
                                      ),
                                      fit: BoxFit.fill)),
                            )),
                ),
              ),
              Positioned(
                  top: 70,
                  left: 200,
                  child: InkWell(
                      onTap: () {
                        showExitPopup();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: colors.whiteTemp,
                      ))),
            ],
          )
        ],
      ),
    );
  }

  bool isLodding = false;

  _updateProfile() async {
    setState(() {
      isLodding = true;
    });
    if (imageFile == null &&
        drivingLicenseBackFile == null &&
        drivingLicenseFile == null &&
        drivingLicenseFile == null &&
        rcBackFile == null &&
        rcFrontFile == null &&
        aadharCardBackFile == null &&
        aadharCardFrontFile == null) {
      Fluttertoast.showToast(msg: "Please upload image");
      setState(() {
        isLodding = false;
      });
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      var headers = {
        'Cookie': 'ci_session=c7d48d7dcbb70c45bae12c8d08e77251655897e8'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('${Urls.baseUrl}Authentication/editDeliveryProfile'));
      request.fields.addAll({
        'user_id': userId ?? "323",
        'user_fullname': nameController.text,
        'user_phone': mobController.text,
        'user_email': emailController.text,
        'vehicle_no': VhicleController.text,
        'pan_card': panController.text,
        'address': addressController.text,
        'state_id': stateidstring.toString(),
        'city_id': cityidstring.toString(),
        'vehicle_type': selected.toString(),
        'vehicle_insurance': _value1.toString(),
        'pollution_emission': _value.toString(),
        // 'user_id': '21',
        // 'user_fullname': 'satish',
        // 'user_phone': '18297311191',
        // 'user_email': 'sasaa12@gmail.com',
        // 'vehicle_no': '7218318',
        // 'pan_card': 'ASHK54FG',
        // 'address': 'ujjian',
        // 'state_id': '9',
        // 'city_id': '17',
        // 'vehicle_type': '4',
        // 'vehicle_insurance': '1',
        // 'pollution_emission': '1',
        // 'gst_number': '1231123',
        // 'gst_type': '1'
      });

      // imageFile;
      // rcFrontFile;
      // rcBackFile;
      // drivingLicenseFile;
      // drivingLicenseBackFile;
      // aadharCardFrontFile;
      // aadharCardBackFile;
      if (imageFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('user_image', imageFile!.path));
      }

      if (drivingLicenseBackFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'driving_licence_photob', drivingLicenseBackFile!.path));
      }

      if (drivingLicenseFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'driving_licence_photof', drivingLicenseFile!.path));
      }

      if (rcBackFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('rc_imageb', rcBackFile!.path));
      }

      if (rcFrontFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('rc_imagef', rcFrontFile!.path));
      }

      if (aadharCardFrontFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhaar_card_photof', aadharCardFrontFile!.path));
      }

      if (aadharCardBackFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'aadhaar_card_photob', aadharCardBackFile!.path));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final reslut = await response.stream.bytesToString();
        print('___________${reslut}__________');
        var finalResult = json.decode(reslut);
        if (finalResult['status'] == true) {
          Navigator.pop(context, 'true');
          Fluttertoast.showToast(msg: "Profile update successfully");
        } else {
          Fluttertoast.showToast(msg: "Invalid Email & Password");
        }
      } else {
        setState(() {
          isLodding = false;
        });
        print(response.reasonPhrase);
      }
    }
  }
}
