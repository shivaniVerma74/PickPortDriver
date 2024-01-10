import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/GetProfileModel.dart';
import '../Models/booking_single_details_,model.dart';
import '../Utils/Color.dart';

import 'package:http/http.dart' as http;

import 'ConfirmScreen.dart';

class PercelDetails extends StatefulWidget {
  GetProfileModel? getProfileModel;

  PercelDetails({this.getProfileModel,this.pId,this.isCheck});
String? pId;
bool? isCheck;
  @override
  State<PercelDetails> createState() => _PercelDetailsState();
}

class _PercelDetailsState extends State<PercelDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOtpApi();
    bookingOrderDetailsApi();
  }

  void _launchPhoneDialer(String? phoneNumber) async {
    if (phoneNumber != null && await canLaunch("tel:$phoneNumber")) {
      await launch("tel:$phoneNumber");
    } else {
      throw 'Could not launch phone dialer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      body:singleBookingModel == null ? Center(child: CircularProgressIndicator()): Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 20),

                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(color: colors.primary),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration:
                          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 45,),
                        const Text(
                          'Parcel Details',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  )
              ),
            ),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child:  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                 // height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children:  [
                                const Text("Parcel Id",style: TextStyle(
                                  color: colors.blackTemp,
                                  fontWeight: FontWeight.bold
                                ),),
                                Text("#${singleBookingModel?.data?.first.saleId}"),
                              ],
                            ),
                            Column(
                              children:  [
                                const Text("Parcel Date",style: TextStyle(
                                    color: colors.blackTemp,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text("${singleBookingModel?.data?.first.bookingDate}"),
                              ],
                            ),
                            Column(
                              children:  [
                                const Text("Parcel Time",style: TextStyle(
                                    color: colors.blackTemp,
                                    fontWeight: FontWeight.bold
                                ),),
                                Text("${singleBookingModel?.data?.first.bookingTime}"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Card(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)
                          ),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.whiteTemp,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text("Sender Name",style: TextStyle(
                                              color: colors.blackTemp,
                                              fontWeight: FontWeight.bold
                                           ),
                                          ),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Icon(Icons.person, size: 20,),
                                              Text("${singleBookingModel?.data?.first.senderName}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children:  [
                                          const Text("Sender Mobile No.",style: TextStyle(
                                              color: colors.blackTemp,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.call, size: 20,),
                                              InkWell(
                                                  onTap: () {
                                                    _launchPhoneDialer("${singleBookingModel?.data?.first.receiverPhone}");
                                                  },
                                                  child: Text("${singleBookingModel?.data?.first.senderName}")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                   Text("Sender Address",style: TextStyle(
                                      color: colors.blackTemp,
                                      fontWeight: FontWeight.bold
                                  ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 20,),
                                      Text("${singleBookingModel?.data?.first.senderFulladdress}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10,),
                        Card(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)
                          ),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors.whiteTemp,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text("Receiver's Name",style: TextStyle(
                                              color: colors.blackTemp,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          const SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Icon(Icons.person, size: 20,),
                                              Text("${singleBookingModel?.data?.first.receiverName}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text("Receiver's Mobile No.",style: TextStyle(
                                              color: colors.blackTemp,
                                              fontWeight: FontWeight.bold
                                          ),),
                                          Row(
                                            children: [
                                              Icon(Icons.call, size:20,),
                                              InkWell(
                                                onTap: () {
                                                  _launchPhoneDialer("${singleBookingModel?.data?.first.receiverPhone}");
                                                },
                                                  child: Text("${singleBookingModel?.data?.first.receiverPhone}"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Text("Receiver's Address",style: TextStyle(
                                      color: colors.blackTemp,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 20,),
                                      Text("${singleBookingModel?.data?.first.reciverFullAddress}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Card(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)
                          ),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                color: colors.whiteTemp,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text("Parcel Details",style: TextStyle(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,fontSize: 18
                                    ),),
                                  ),
                                   const SizedBox(height: 10,),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children:  [
                                       const Text("Material Category",style: TextStyle(
                                           color: colors.blackTemp,
                                           fontWeight: FontWeight.bold,fontSize: 15
                                         ),
                                       ),
                                       Text("${singleBookingModel?.data?.first.title}"),
                                     ],
                                   ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text("Parcel Weight",style: TextStyle(
                                          color: colors.blackTemp,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                          ),
                                      ),
                                      Row(
                                        children: [
                                          Text("${singleBookingModel?.data?.first.parcelWeight}Kg"),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text("Total Distance",style: TextStyle(
                                          color: colors.blackTemp,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                      )),
                                      Text("${singleBookingModel?.data?.first.distance} Km."),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text("Amount",style: TextStyle(
                                          color: colors.blackTemp,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                      )),
                                      Text("₹ ${singleBookingModel?.data?.first.totalAmount}"),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children:  [
                                  //     const Text("Commission Charge",style: TextStyle(
                                  //         color: colors.blackTemp,
                                  //         fontWeight: FontWeight.bold,fontSize: 15
                                  //     )),
                                  //     Text("₹ ${singleBookingModel?.data?.first.adminCommission}"),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Amount To be paid",style: TextStyle(
                                          color: colors.blackTemp,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                      ),
                                      ),
                                      Text("₹ ${singleBookingModel?.data?.first.totalAmount}"),
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text("Payment Status",style: TextStyle(
                                          color: colors.blackTemp,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                      ),
                                      ),
                                      singleBookingModel?.data?.first.paymentMethod == "online" ?
                                      const Text("Paid", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),):
                                      const Text("UnPaid", style: TextStyle(color: Colors.red,  fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:   [
                                      const Text("Payment Method",style: TextStyle(
                                          color: colors.red,
                                          fontWeight: FontWeight.bold,fontSize: 15
                                      )),
                                      Text("${singleBookingModel?.data?.first.paymentMethod}", style: TextStyle(color: Colors.red))
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    //dashColor: Colors.black,
                                    dashGradient: [Colors.grey,Colors.grey],
                                    dashRadius: 0.0,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                   dashGapGradient: [Colors.grey,Colors.grey],
                                    dashGapRadius: 0.0,
                                  ),
                                      SizedBox(height: 20,),
                                      Center(
                                        child: Container(
                                          height: 45,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Center(
                                            child: Text("Delivery Status",style: TextStyle(
                                                color: colors.primary,fontWeight: FontWeight.bold,fontSize: 18
                                            ),),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Center(child: Image.asset("assets/images/status.png")),
                                      SizedBox(height: 10,),
                                      singleBookingModel?.data?.first.status == "4"  ?
                                      const Center(child: Text("Delivered",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),)):
                                      Center(child: Text("Pending",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),)) ,
                                     widget.isCheck == true?  SizedBox.shrink(): Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: colors.whiteTemp,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                value: selectedStatus,
                                                hint: Text("Update Delivery Status",style: TextStyle(color: colors.blackTemp,fontWeight: FontWeight.bold),),
                                                isExpanded: true,
                                                onChanged: (String? newValue) {
                                                  if(selectedStatus == 'Out for Delivery' || selectedStatus == "Cancel"){
                                                    orderUpdateApi(selectedStatus);
                                                  }

                                                  setState(() {
                                                    selectedStatus = newValue!;
                                                  });
                                                },
                                                items: <String>['Order Picked Up','Out for Delivery','Delivered','Cancel']
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),

                                                  );
                                                }).toList(

                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (selectedStatus == 'Delivered' || selectedStatus == 'Order Picked Up')
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            selectedStatus == 'Order Picked Up'? Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Text("OTP:${senderOTP}"),
                                            ):Padding(
                                              padding: const EdgeInsets.only(left: 20),
                                              child: Text("OTP:${receiverOtp}"),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16.0,left: 20,right: 20),
                                              child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(

                                                    border: Border.all(),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: TextFormField(
                                                  maxLength: 6,
                                                  controller: _otpController,
                                                  decoration: const InputDecoration(
                                                    counterText: "",
                                                    contentPadding: EdgeInsets.only(left: 5),
                                                    border: InputBorder.none,
                                                    hintText: 'Enter OTP',
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  )


                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                      selectedStatus == 'Order Picked Up' ||   selectedStatus == "Delivered" ?   InkWell(
                          onTap: (){

                            orderDelevertCompleteByOtp();
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.primary
                            ),
                            child: Center(child: Text("Update",style: TextStyle(fontSize: 15,color: colors.whiteTemp),)),
                          ),
                        ):SizedBox.shrink(),
                        SizedBox(height: 20,),

                      ],
                    ),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  final _otpController =  TextEditingController();
  String? selectedStatus ; // Default status
String? orderId,senderOTP,receiverOtp;
  SingleBookingModel ? singleBookingModel;
  bookingOrderDetailsApi() async {
    var headers = {
      'Cookie': 'ci_session=7e0de117fa84bd318ef38c6fd83f368d5bbc9700'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Urls.baseUrl}Payment/api_single_parcel_details'));
    request.fields.addAll({
      'order_id':widget.pId.toString()
    });
   print('____Som___ggg___${request.fields}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
       var result = await response.stream.bytesToString();
       var finalResult  =  SingleBookingModel.fromJson(json.decode(result));
       setState(() {
         singleBookingModel = finalResult;
         orderId = singleBookingModel?.data?.first.orderId.toString();
         senderOTP = singleBookingModel?.data?.first.senderOtp.toString();
         receiverOtp = singleBookingModel?.data?.first.receiverOtp.toString();
         print('____Som______${receiverOtp}_________');
       });
    }
    else {
    print(response.reasonPhrase);
    }

  }
   orderDelevertCompleteByOtp() async {
    if(_otpController.text.isEmpty){
      Fluttertoast.showToast(msg: 'please enter otp');
    }else if(_otpController.text.length < 4){
      Fluttertoast.showToast(msg: 'please enter right otp');
    }else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      var headers = {
        'Cookie': 'ci_session=27190b0a94b885f1a7656c45b1492a2c7a91a862'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Urls.baseUrl}Authentication/otp_order_complete'));
      request.fields.addAll({
        'user_id': userId ?? '300',
        'otp': _otpController.text,
        'deliveryboy_order_status': selectedStatus == "Delivered" ? "4" : "3",
        'order_id':widget.pId.toString()
      });
     print('____Som______${request.fields}_________');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _otpController.clear();
        var result = await response.stream.bytesToString();
        var finalResult = jsonDecode(result);
          Fluttertoast.showToast(msg: "${finalResult['meassge']}");
          if(finalResult['status'] == true){
            if(selectedStatus == 'Delivered'){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfimeScreen()));
            }

          }else{
            Fluttertoast.showToast(msg: '${finalResult['data']}');
          }

        // if(finalResult['status']) {
        //   // if (status == '3') {
        //   //   Fluttertoast.showToast(msg: 'Order Picked Successfully');
        //   //   Navigator.pop(context);
        //   //
        //   // } else if (status == '4') {
        //   //   Fluttertoast.showToast(
        //   //       msg: 'Order has been delivered successfully');
        //   //   // Navigator.pushReplacement(
        //   //   //     context, MaterialPageRoute(builder: (context) => BottomNav()));
        //   // }
        // }else{
        //  //
        // }
      } else {
        _otpController.clear();
        print(response.reasonPhrase);
      }
    }
  }
   orderUpdateApi(String? status) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final userId = prefs.getString('userId');
     var headers = {
       'Cookie': 'ci_session=5f7e1cc6f4bb283533aa8649c10608e57fef7dd1'
     };
     var request = http.MultipartRequest('POST', Uri.parse('${Urls.baseUrl}Authentication/api_order_change_status'));
     request.fields.addAll({
       'user_id':userId ?? '323',
       'order_id': orderId.toString(),
       'deliveryboy_order_status': status == "Order Picked Up" ? "3" :status == "Out for Delivery" ? "4" :status == "Cancel" ? "0" : ""
     });
     print('____Som______${request.fields}_________');
     request.headers.addAll(headers);
     http.StreamedResponse response = await request.send();
     if (response.statusCode == 200) {
       var result  =  await response.stream.bytesToString();
       var finalResult =  jsonDecode(result);

       // if (status == 'Order Picked Up') {
       //   Fluttertoast.showToast(msg: 'Order Picked Successfully');
       //  // Navigator.pop(context);
       //
       // }
       if (status == 'Out for Delivery') {
         Fluttertoast.showToast(msg: 'Out for Delivery');
         //Navigator.pop(context);
       }else if (status == 'Cancel') {
         Fluttertoast.showToast(
             msg: 'Order Canceled Success');

       }
       setState(() {
        // Fluttertoast.showToast(msg: "${finalResult['message']}");
       });
     }
     else {
     print(response.reasonPhrase);
     }

   }
   String? Otp;
   getOtpApi() async {
     var headers = {
       'Cookie': 'ci_session=127419c90abafa0b72f2bc62ac629ffdb6745994'
     };
     var request = http.MultipartRequest('POST', Uri.parse('${Urls.baseUrl}Authentication/api_delivery_otp'));
     request.fields.addAll({
       'order_id':widget.pId.toString()
     });
     request.headers.addAll(headers);

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {
       var result = await response.stream.bytesToString();
       var finalResult  = jsonDecode(result);
       setState(() {
         Otp =   finalResult['data'];
       });
     }
     else {
     print(response.reasonPhrase);
     }

   }

}

