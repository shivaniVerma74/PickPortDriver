import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/AuthViews/SignUpScreen.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:http/http.dart'as http;

import '../Utils/ApiPath.dart';
import '../Utils/Color.dart';
import '../Views/GetHelp.dart';

class AddBankDetails extends StatefulWidget {
   AddBankDetails({Key? key,this.name,this.mobile,this.email,this.address,this.adhar,this.long,this.lat,this.cPass,this.Licence,this.pan,this.pass,this.rc,this.refer,this.vcNo,this.image,this.cID,this.sId,this.Insurance,this.pollution,this.vType}) : super(key: key);
 String? name,email,mobile,adhar,Licence,rc,vcNo,pan,refer,pass,cPass,address,image,cID,sId,vType,Insurance,pollution;
 double? lat,long;
  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  TextEditingController bankName = TextEditingController();
  TextEditingController accountHolderName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  int selected = 0;
  final _formKey = GlobalKey<FormState>();

  Future<bool> showExitPopupl(int valuef, valueb) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
            child: Text('Upload Check Book ',
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
                    child: const Text('Check Book Front',
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

  final ImagePicker _picker = ImagePicker();

  _getFromGallery(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          chechBookFile = File(pickedFile.path);
        });
      }
      else if (vall == 2) {
        setState(() {
          chechBookBackFile = File(pickedFile.path);
        });
      }
    }
  }

  File? chechBookFile;
  File? chechBookBackFile;

  _getCamera(int vall) async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      if (vall == 1) {
        setState(() {
          chechBookFile = File(pickedFile.path);
        });
      }
      else if (vall == 2) {
        setState(() {
          chechBookBackFile = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('____Som______${widget.image}_________');
    return Scaffold(
      backgroundColor: colors.primary,
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: colors.primary),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Bank Details',
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
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: const Text(
                            'Get Help ?',
                            style: TextStyle(color: colors.primary, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Text(
                  //   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters',
                  //   style: TextStyle(fontSize: 12, color: Colors.white),
                  // )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
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
                          controller: bankName,
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child:  Image.asset(
                                'assets/images/BANK NAME.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Bank Name",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Bank Name is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                          controller: accountHolderName,
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Image.asset(
                                'assets/images/ACCOUNT HOLDER NAME.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Account Holder Name",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Account Holder Name is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                          controller: accountNumber,
                          maxLength: 14,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Image.asset(
                                'assets/images/ACCOUNT  NUMBER.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            counterText: "",
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Account Number",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "Account Number is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                          controller: ifscCode,
                          maxLength: 11,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Image.asset(
                                'assets/images/IFSC CODE.png',
                                scale: 1.3,
                                color: colors.secondary,
                              ),
                            ),
                            counterText: "",
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "IFSC Code",
                          ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "IFSC Code is required";
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Account Type',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selected = 0;
                            });
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Icon(
                                  selected == 0
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off_outlined,
                                  color: colors.secondary,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Saving Account',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
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
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text(
                                  'Current Account',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
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
                            hintText: "Check Book Image",
                          ),
                          // validator: (v) {
                          //   if (v!.isEmpty) {
                          //     return "Driving License is required";
                          //   }
                          // },
                        ),
                      ),
                    ),
                    chechBookFile != null
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
                                          File(chechBookFile!.path)),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                        chechBookBackFile != null
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
                                      image: FileImage(File(chechBookBackFile!.path)),
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
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            // signUpApi();
                            signUp();
                          }else if(selected == ""){
                            Fluttertoast.showToast(msg: "Select Account Type");
                          }else{
                            Fluttertoast.showToast(msg: "Fill All The Fields");
                          }
                      },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child:  Center(
                              child:isLoding == true ? Center(child: CircularProgressIndicator()):Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white,fontSize: 18),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.1,
                    ),
                    // Center(
                    //   child: Container(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text('Already have an Account?'),
                    //         InkWell(
                    //             onTap: () {
                    //               Navigator.push(
                    //                   context,
                    //                   MaterialPageRoute(
                    //                       builder: (context) => LoginScreen()));
                    //             },
                    //             child: Text(
                    //               ' Login',
                    //               style: TextStyle(color: colors.secondary),
                    //             ))
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  bool? isLoding =  false;

  signUp() async {
    var headers = {
      'Cookie': 'ci_session=321abd54770ce394b6c89c07e2d20a0996c1cff8'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/pickport/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname':widget.name.toString(),
      'user_phone': widget.mobile.toString(),
      'user_email':widget.email.toString(),
      'vehicle_no':widget.vcNo.toString(),
      // 'pan_card':widget.pan.toString(),
      'address':widget.address.toString(),
      'state_id':widget.sId.toString(),
      'city_id': widget.cID.toString(),
      'user_password':widget.pass.toString(),
      'refferal_code':widget.refer.toString(),
      'vehicle_type': widget.vType.toString(),
      'vehicle_insurance':widget.Insurance.toString(),
      'pollution_emission':widget.pollution.toString(),
      'firebaseToken': '',
      'bank_name':bankName.text,
      'account_holder_name':accountNumber.text,
      'account_number':accountHolderName.text,
      'ifsc_code':ifscCode.text,
      'account_type':selected.toString()
    });
    print("${request.fields} ${request.files}"+"_______________++++++++++");
    request.files.add(await http.MultipartFile.fromPath('user_image', '${imageFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('driving_licence_photob', '${drivingLicenseBackFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('driving_licence_photof', '${drivingLicenseFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('rc_imageb', '${rcBackFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('rc_imagef', '${rcFrontFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('aadhaar_card_photob', '${aadharCardBackFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('aadhaar_card_photof', '${aadharCardFrontFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('pan_card_photof', '${panCardFile?.path}'));
    request.files.add(await http.MultipartFile.fromPath('pan_card_photob', '${pancardBackFile?.path}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    //print(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      print("successs");
    print(await response.stream.bytesToString());

    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LoginScreen();
    }));
    }
    else {
    print(response.reasonPhrase);
    }
  }

  signUpApi() async {
    setState(() {
      isLoding = true;
    });
    var headers = {
      'Cookie': 'ci_session=f71fdd0b4cece7410bf8aa176b4fbff6e9afb34c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Urls.baseUrl}Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname':widget.name.toString(),
      'user_phone': widget.mobile.toString(),
      'user_email':widget.email.toString(),
      'vehicle_no':widget.vcNo.toString(),
      'pan_card':widget.pan.toString(),
      'driving_licence_no':widget.Licence.toString(),
      'aadhaar_card_no':widget.adhar.toString(),
      'rc_number':widget.rc.toString(),
      'address':widget.address.toString(),
      'state_id':widget.sId.toString(),
      'city_id': widget.cID.toString(),
      'user_password':widget.pass.toString(),
      'refferal_code':widget.refer.toString(),
      'vehicle_type': widget.vType.toString(),
      'vehicle_insurance':widget.Insurance.toString(),
      'pollution_emission':widget.pollution.toString(),
      'firebaseToken': '',
      'bank_name':bankName.text,
      'account_holder_name':accountNumber.text,
      'account_number':accountHolderName.text,
      'ifsc_code':ifscCode.text,
      'account_type':selected.toString()
    });
    print('____Som______${request.fields}_________');
    request.files.add(await http.MultipartFile.fromPath('user_image',imageFile?.path ?? ""));
    print('____Som______${request.files}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    var result = await response.stream.bytesToString();
    var finalResult  =  jsonDecode(result);
    Fluttertoast.showToast(msg: "${finalResult['message']}");
    setState(() {
      isLoding = false;
    });
    if(finalResult['status'] == true){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }else{
      Fluttertoast.showToast(msg: "${finalResult['message']}");
    }

    }
    else {
      setState(() {
        isLoding = false;
      });
    print(response.reasonPhrase);
    }

  }
}
