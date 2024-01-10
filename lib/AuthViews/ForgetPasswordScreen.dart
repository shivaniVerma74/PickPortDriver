import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/AuthViews/verificationOtp.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:http/http.dart' as http;
import '../Utils/Color.dart';

class Forget extends StatefulWidget {
  const Forget({Key? key}) : super(key: key);

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController mobileNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String mobileOtp = '';
  String mobileNo = '';
  loginWithMobileNumberApi() async {
    var headers = {
      'Cookie': 'ci_session=418394d486487780888e62b557385cca98626dde'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/pickport/api/Authentication/DeliveryLogin'));
    request.fields.addAll({'user_phone': mobileNumber.text});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);

      setState(() {
        isLoading = false;
      });
      setState(() {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      });
      if (finalResult['status'] == false) {
        Fluttertoast.showToast(msg: "${finalResult['message']}");
      } else {
        mobileOtp = finalResult['data']['otp'];
        mobileNo = finalResult['data']['user_phone'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerificationPage(
                  fromForgetPassword: true,
                  mobile: mobileNo,
                  otp: mobileOtp,
                )));
        setState(() {
          isLoading = false;
        });
      }
      // Navigator.push(context, MaterialPa
      // geRoute(builder: (context)=>))
    } else {
      setState(() {
        setState(() {
          isLoading = false;
        });
      });
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              //  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: colors.primary),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          'Need Help ?',
                          style: TextStyle(
                              color: colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'Welcome To PickPort',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Enter Mobile Number Associated With Your Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                          maxLength: 10,
                          controller: mobileNumber,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            counterText: "",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.call,
                                color: CustomColors.accentColor,
                              ),
                            ),
                            contentPadding: EdgeInsets.only(top: 22, left: 5),
                            border: InputBorder.none,
                            hintText: "Mobile No",
                          ),
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
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate() &&
                              isLoading == false) {
                            loginWithMobileNumberApi();
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(15)),
                            height: 45,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ),
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
}
