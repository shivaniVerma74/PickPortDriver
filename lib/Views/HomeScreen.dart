import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jdx/Controller/home_controller.dart';
import 'package:jdx/Models/get_driver_rating_response.dart';
import 'package:jdx/Models/order_accept_response.dart';
import 'package:jdx/Models/order_history_response.dart';
import 'package:jdx/Views/order_details.dart';
import 'package:jdx/Views/parcel_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/Acceptorder.dart';
import '../Models/GetProfileModel.dart';
import '../Models/getSliderModel.dart';
import '../Models/parcel_history_response.dart';
import '../Utils/ApiPath.dart';
import '../Utils/Color.dart';
import '../Utils/CustomColor.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';
import '../services/location/location.dart';
import 'package:http/http.dart' as http;

import 'MyAccount.dart';
import 'NotificationScreen.dart';
import 'ParcelDetails.dart';
import 'SupportNewScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Api api = Api();
  bool isSwitched = true;
  List<OrderHistoryData> orderHistoryList = [];
  Position? _position;

  bool isLoading = false;
  String? name, image;
  GetDriverRating? _driverRating;
  bool isOnline = true;

  ///active order

  //List<AccepetedOrderList> parcelDataList = [];
  Acceptorder? parcelDataList;
  bool isLoading2 = false;
  List<ParcelHistoryDataList> pastParcelDataList = [];
  bool isLoading3 = false;
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    getSliderApi();
    inIt();
    super.initState();
  }

  GetProfileModel? getProfileModel;
  String qrCodeResult = "Not Yet Scanned";

  final CarouselController carouselController = CarouselController();

  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(" this is  User++++++++++++++>$userId");
    var headers = {
      'Cookie': 'ci_session=6de5f73f50c4977cb7f3af6afe61f4b340359530'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Urls.baseUrl}User_Dashboard/getUserProfile'));
    request.fields.addAll({'user_id': userId.toString()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalResult = GetProfileModel.fromJson(jsonDecode(result));
      setState(() {
        getProfileModel = finalResult;
        print(
            '____Som______${getProfileModel?.data?[0].userFullname}_________');
        Fluttertoast.showToast(msg: qrCodeResult);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  inIt() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    userId = prefs1.getString('userId');
    name = prefs1.getString('userName');
    image = prefs1.getString('userImage');

    _position = await getUserCurrentPosition();

    print("${_position!.longitude}________ggggg______");
    getUserOrderHistory();
    getDriverRating(userId ?? '300');
  }

  GetSliderModel? getSliderModel;
  getSliderApi() async {
    var headers = {
      'Cookie': 'ci_session=8c63df600f4c9c930d8b1e2d1e10feb8278887c0'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Authentication/delivery_bannerList'));
    request.fields.addAll({'type': '3'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print(result);
      var finalResult = GetSliderModel.fromJson(json.decode(result));
      setState(() {
        getSliderModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  int _currentPost = 0;
  _buildDots() {
    List<Widget> dots = [];
    if (getSliderModel == null) {
    } else {
      for (int i = 0; i < getSliderModel!.data!.length; i++) {
        dots.add(
          Container(
            margin: EdgeInsets.all(1.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPost == i ? colors.primary : colors.secondary,
            ),
          ),
        );
      }
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: colors.primary,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: colors.primary,
            elevation: 0,
            toolbarHeight: 70,
            leadingWidth: 0,
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyAccount()),
                    );
                  },
                  child: Container(
                      height: 80,
                      width: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(),
                      child: getProfileModel?.data?[0].userImage == null
                          ? const Center(
                          child: CircularProgressIndicator(),
                      ): ClipRRect(
                              borderRadius: BorderRadius.circular(80),
                              child: Image.network(
                                "${getProfileModel?.data?[0].userImage}",
                                fit: BoxFit.fill,
                              ),
                      ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello,',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '${getProfileModel?.data?[0].userFullname}',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              ],
            ),

            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.notification_important_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SupportNewScreen()));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.headset_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
            // leading: Image.asset('assets/images/jdx_logo.png',
            //     color: Colors.transparent),
            // backgroundColor: Colors.cyan.withOpacity(0.10),
            // elevation: 0,
            // actions: [
            //   Row(
            //     children: [
            //       Row(
            //         children: [
            //           isSwitched
            //               ? const Text(
            //                   "Online",
            //                   style: TextStyle(color: Colors.green),
            //                 )
            //               : const Text(
            //                   "Offline",
            //                   style: TextStyle(color: Colors.pink),
            //                 ),
            //           const SizedBox(
            //             width: 10,
            //           ),
            //           Switch.adaptive(
            //               activeColor: Colors.green,
            //               value: isSwitched,
            //               onChanged: (val) {
            //                 setState(() {
            //                   isSwitched = val;
            //                   getUserStatusOnlineOrOffline();
            //                 });
            //               }),
            //         ],
            //       ),
            //     ],
            //   ),
            //   // Container(
            //   //   height: 10,
            //   //   width: 80,
            //   //   child: CupertinoSwitch(
            //   //     value: _switchValue,
            //   //     onChanged: (value) {
            //   //       setState(() {
            //   //         _switchValue = value;
            //   //       });
            //   //     },
            //   //   ),
            //   // ),
            // ],
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getSliderModel == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : CarouselSlider(
                                    items: getSliderModel!.data!
                                        .map(
                                          (item) => Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Container(
                                                        height: 200,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                  "${item.sliderImage}",
                                                                ),
                                                                fit: BoxFit.fill)),
                                                      )),
                                                ),
                                              ]),
                                        )
                                        .toList(),
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                        height: 150,
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
                                        autoPlay: true,
                                        aspectRatio: 1.8,
                                        viewportFraction: 1,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _currentPost = index;
                                          });
                                        })),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildDots(),
                            ),
                            // sliderPointers (items , currentIndex),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                            'Deliveries',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _segmentButton(),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text(
                              'New delivery list',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        selectedSegmentVal == 0
                            ? SizedBox(
                                width: double.maxFinite,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : orderHistoryList.isEmpty
                                        ? const Center(
                                            child: Text('Data not available'))
                                        : ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: orderHistoryList.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: orderHistoryList[index]
                                                            .isAccepted ??
                                                        false
                                                    ? () {
                                                        print(
                                                            '____Som___jj___${orderHistoryList[index].orderId}_________');
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //       builder: (context) =>
                                                        //           OrderDetailView(orderDetail: orderHistoryList[index]),
                                                        //     ));
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PercelDetails(
                                                                        pId: orderHistoryList[index]
                                                                            .orderId)));
                                                      }
                                                    : null,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  elevation: 2,
                                                  color: Colors.white,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              8.0),
                                                                  child: Text(
                                                                      "Customer Name",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              colors.black54)),
                                                                ),
                                                                Text(
                                                                    orderHistoryList[
                                                                                index]
                                                                            .senderName ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: colors
                                                                            .primary)),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                    DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(orderHistoryList[index]
                                                                            .onDate),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: colors
                                                                            .black54)),
                                                                Text(
                                                                    "Rs ${orderHistoryList[index].parcelDetails.first.materialInfo?.price ?? ''}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: colors
                                                                            .blackTemp)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),

                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    decoration: const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .red),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .pin_drop,
                                                                      size: 14,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 40,
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(8),
                                                                    decoration: const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .grey),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .pin_drop,
                                                                      size: 14,
                                                                      color: Colors
                                                                          .yellow,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Text(
                                                                          "Pick up Point",
                                                                          style: TextStyle(
                                                                              color: colors.primary,
                                                                              fontSize: 12),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.65,
                                                                          child:
                                                                              Text(
                                                                            orderHistoryList[index].senderAddress,
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Text(
                                                                          "Drop Point",
                                                                          style: TextStyle(
                                                                              color: colors.primary,
                                                                              fontSize: 12),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.65,
                                                                          child:
                                                                              Text(
                                                                            orderHistoryList[index].senderAddress,
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        // Row(
                                                        //   crossAxisAlignment:
                                                        //       CrossAxisAlignment
                                                        //           .start,
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceBetween,
                                                        //   children: [
                                                        //     Column(
                                                        //       crossAxisAlignment:
                                                        //           CrossAxisAlignment
                                                        //               .start,
                                                        //       children: [
                                                        //         const Text(
                                                        //           "Mobile No",
                                                        //           style: TextStyle(
                                                        //               fontSize:
                                                        //                   13,
                                                        //               color: Color(
                                                        //                   0xFFBF2331)),
                                                        //         ),
                                                        //         Text(orderHistoryList[
                                                        //                     index]
                                                        //                 .phoneNo ??
                                                        //             ''),
                                                        //       ],
                                                        //     ),
                                                        //     Column(
                                                        //       crossAxisAlignment:
                                                        //           CrossAxisAlignment
                                                        //               .start,
                                                        //       children: [
                                                        //         const Text(
                                                        //           "Material category ",
                                                        //           style: TextStyle(
                                                        //               fontSize:
                                                        //                   13,
                                                        //               color: Color(
                                                        //                   0xFFBF2331)),
                                                        //         ),
                                                        //         SizedBox(
                                                        //           width: 100,
                                                        //           child: Text(
                                                        //             orderHistoryList[index]
                                                        //                     .senderAddress ??
                                                        //                 '',
                                                        //             maxLines: 3,
                                                        //             overflow:
                                                        //                 TextOverflow
                                                        //                     .clip,
                                                        //           ),
                                                        //         ),
                                                        //       ],
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        // Row(
                                                        //   crossAxisAlignment:
                                                        //       CrossAxisAlignment
                                                        //           .start,
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceBetween,
                                                        //   children: [
                                                        //     Column(
                                                        //       crossAxisAlignment:
                                                        //           CrossAxisAlignment
                                                        //               .start,
                                                        //       children: [
                                                        //         const Text(
                                                        //           "Recipient Address",
                                                        //           style: TextStyle(
                                                        //               fontSize:
                                                        //                   13,
                                                        //               color: Color(
                                                        //                   0xFFBF2331)),
                                                        //         ),
                                                        //         SizedBox(
                                                        //           width: 100,
                                                        //           child: Text(
                                                        //             orderHistoryList[index]
                                                        //                     .senderAddress ??
                                                        //                 '',
                                                        //             maxLines: 3,
                                                        //             overflow:
                                                        //                 TextOverflow
                                                        //                     .clip,
                                                        //           ),
                                                        //         ),
                                                        //       ],
                                                        //     ),
                                                        //     Padding(
                                                        //       padding:
                                                        //           const EdgeInsets
                                                        //                   .only(
                                                        //               right:
                                                        //                   16),
                                                        //       child: Card(
                                                        //         elevation: 0,
                                                        //         color: CustomColors
                                                        //             .accentColor,
                                                        //         child: Padding(
                                                        //           padding:
                                                        //               const EdgeInsets
                                                        //                       .all(
                                                        //                   8.0),
                                                        //           child: Column(
                                                        //             crossAxisAlignment:
                                                        //                 CrossAxisAlignment
                                                        //                     .center,
                                                        //             children: [
                                                        //               const Text(
                                                        //                 "order Amount",
                                                        //                 textAlign:
                                                        //                     TextAlign.center,
                                                        //                 style: TextStyle(
                                                        //                     fontSize:
                                                        //                         14,
                                                        //                     color:
                                                        //                         CustomColors.White,
                                                        //                     fontWeight: FontWeight.bold),
                                                        //               ),
                                                        //               Text(
                                                        //                 '₹ ' + orderHistoryList[index].orderAmount ??
                                                        //                     '',
                                                        //                 style: TextStyle(
                                                        //                     fontSize:
                                                        //                         14,
                                                        //                     fontWeight:
                                                        //                         FontWeight.bold,
                                                        //                     color: CustomColors.White),
                                                        //               ),
                                                        //             ],
                                                        //           ),
                                                        //         ),
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        // Row(
                                                        //   crossAxisAlignment:
                                                        //       CrossAxisAlignment
                                                        //           .start,
                                                        //   mainAxisAlignment:
                                                        //       MainAxisAlignment
                                                        //           .spaceBetween,
                                                        //   children: [
                                                        //     Column(
                                                        //       crossAxisAlignment:
                                                        //           CrossAxisAlignment
                                                        //               .start,
                                                        //       children: [
                                                        //         const Text(
                                                        //           "Recipient Flat Number",
                                                        //           style: TextStyle(
                                                        //               fontSize:
                                                        //                   13,
                                                        //               color: Color(
                                                        //                   0xFFBF2331)),
                                                        //         ),
                                                        //         Text(orderHistoryList[
                                                        //                 index]
                                                        //             .saleIds
                                                        //             .toString()),
                                                        //       ],
                                                        //     ),
                                                        //     Column(
                                                        //       crossAxisAlignment:
                                                        //           CrossAxisAlignment
                                                        //               .start,
                                                        //       children: [
                                                        //         const Text(
                                                        //           "Date                        ",
                                                        //           style: TextStyle(
                                                        //               fontSize:
                                                        //                   13,
                                                        //               color: Color(
                                                        //                   0xFFBF2331)),
                                                        //         ),
                                                        //         Text(orderHistoryList[
                                                        //                 index]
                                                        //             .onDate
                                                        //             .toString()
                                                        //             .substring(
                                                        //                 0, 11)),
                                                        //       ],
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        // const SizedBox(
                                                        //   height: 10,
                                                        // ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: orderHistoryList[index]
                                                                            .isAccepted ??
                                                                        false
                                                                    ? null
                                                                    : () {
                                                                        setState(() {
                                                                          orderHistoryList[index].isAccepted = true;
                                                                          orderRejectedOrAccept(index, context);
                                                                        });
                                                                      },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets.all(10),
                                                                  width: MediaQuery.of(context).size.width *
                                                                      0.35,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color: orderHistoryList[index].isAccepted ??
                                                                              false
                                                                          ? Colors
                                                                              .grey
                                                                          : Colors
                                                                              .green),
                                                                  child: Center(
                                                                    child: Text(
                                                                        orderHistoryList[index].isAccepted ?? false
                                                                            ? 'Accepted'
                                                                            : 'Accept',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            orderHistoryList[
                                                                            index]
                                                                        .isAccepted ??
                                                                    false
                                                                ? SizedBox
                                                                    .shrink()
                                                                : Expanded(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        orderRejectedOrAccept(
                                                                            index,
                                                                            context,
                                                                            isRejected:
                                                                                true);
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.35,
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            color: Colors.red),
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              Text(
                                                                            'Reject',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                              )
                            : selectedSegmentVal == 1
                                ? activeOrder()
                                : completeOrder(),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                )
                // const SizedBox(
                //   height: 10,
                // ),
                // _driverRating?.rating == null
                //     ? const SizedBox()
                //     : Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Hi, ${name.toString().capitalizeFirst}',
                //             style: TextStyle(
                //                 color: Colors.green,
                //                 fontWeight: FontWeight.w400,
                //                 fontSize: 30),
                //           ),
                //           Row(
                //             children: [
                //               RatingBar.builder(
                //                 itemSize: 18,
                //                 ignoreGestures: true,
                //                 initialRating:
                //                     double.parse(_driverRating?.rating ?? ''),
                //                 minRating: 1,
                //                 direction: Axis.horizontal,
                //                 allowHalfRating: true,
                //                 itemCount: 5,
                //                 itemPadding: EdgeInsets.zero,
                //                 itemBuilder: (context, _) => Icon(
                //                   Icons.star,
                //                   color: Colors.red,
                //                 ),
                //                 onRatingUpdate: (rating) {
                //                   print(rating);
                //                 },
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //               Text.rich(TextSpan(children: [
                //                 TextSpan(
                //                     text: '${_driverRating?.rating}',
                //                     style: const TextStyle(color: Colors.red)),
                //                 const TextSpan(
                //                     text: '/5.0',
                //                     style: TextStyle(color: Colors.grey)),
                //               ]))
                //             ],
                //           ),
                //         ],
                //       ),
                // const SizedBox(
                //   height: 20,
                // // ),
                // const Text(
                //   'Current Leads',
                //   style: TextStyle(
                //       color: Colors.redAccent,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 17),
                // ),
              ],
            ),
          ),
          bottomSheet: Container(
            color: colors.primary,
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Row(children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    isOnline = true;
                  });
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: isOnline ? Colors.green : Colors.white,
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                            fontSize: 16,
                            color: isOnline ? Colors.green : Colors.white),
                      )
                    ],
                  ),
                ),
              )),
              Container(
                width: 1,
                height: 60,
                color: Colors.white,
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    isOnline = false;
                  });
                },
                child: Container(
                  child: Center(
                    child: Text(
                      'Offline',
                      style: TextStyle(
                          fontSize: 16,
                          color: isOnline ? Colors.white : Colors.red),
                    ),
                  ),
                ),
              ))
            ]),
          ),
        );
      },
    );
  }

  void getUserStatusOnlineOrOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.status] = isSwitched ? '2' : '1';
      var res = await api.userOfflineOnlineApi(body);
      if (res.status) {
        print('_____success____');

        // responseData = res.data?.userid.toString();
      } else {
        Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email & Password");
    } finally {}
  }

  void getUserOrderHistory() async {
    isLoading = true;
    setState(() {});
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');*/
    try {
      Map<String, String> body = {};
      body[RequestKeys.lat] = _position?.latitude.toString() ?? '';
      body[RequestKeys.long] = _position?.longitude.toString() ?? '';
      var res = await api.getOrderHistoryData(body);
      print('____ffff_______${body}__________');
      if (res.status ?? false) {
        if (kDebugMode) {
          print('_____success____');
        }
        // responseData = res.data?.userid.toString();
        orderHistoryList = res.data ?? [];
        isLoading = false;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.message}');
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email & Password");
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  void orderRejectedOrAccept(int index, BuildContext context, {bool? isRejected}) async {
    if (isRejected ?? false) {
      orderHistoryList.removeAt(index);
      setState(() {});
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    var headers = {
      'Cookie': 'ci_session=022988262cd0c123b1183501ce33a881b00f1daa'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/accept_order_request'));
    print(request.fields);
    request.fields.addAll({
      'user_id': userId ?? '',
      'order_id': orderHistoryList[index].orderId,
      'status': isRejected ?? false ? '0' : '2'
    });
    print('____Som______${request.fields}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    http.Response.fromStream(response).then((response) {
      print('___________${response.statusCode}__________');
      if (response.statusCode == 200) {
        log(response.body);
        var res = OrderAcceptApiResponse.fromJson(jsonDecode(response.body));
        Fluttertoast.showToast(msg: res.message ?? '');
      }
    });

    /*try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.orderId] = orderHistoryList[index].orderId;
      body[RequestKeys.status] = isRejected ?? false ? '1' : '2';
      var res = await api.getAcceptedOrderData(body);


      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        Fluttertoast.showToast(msg: res.message ?? '');
        setState(() {});  Fluttertoast.showToast(msg: "Something went wrong");
      } else {
        Fluttertoast.showToast(msg: res.message ?? '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {}*/
  }

  getDriverRating(String driverId) async {
    var headers = {
      'Cookie': 'ci_session=6e2bbfaeac31fb0c3fcbcd0ae36ef35cb60a73d9'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/pickport/api/Authentication/get_delivery_boy_rating'));
    request.fields.addAll({RequestKeys.deliveryBoyId: driverId});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('__________${request.fields}_____________');

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetDriverRating.fromJson(jsonDecode(result));
      _driverRating = finalResult;
    } else {
      print(response.reasonPhrase);
    }
    setState(() {});
  }

  int selectedSegmentVal = 0;

  Widget _segmentButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setSegmentValue(0),
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 0
                                ? colors.primary
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Current Delivery',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary),
                      ),
                    )
                    //
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(0),
                    //   child: const Text(
                    //     'Current Delivery',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 13,
                    //         color: colors.primary),
                    //   ),
                    // ),
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setSegmentValue(1),
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 1
                                ? colors.primary
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Scheduled Delivery',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary),
                      ),
                    )
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(1),
                    //   child: const FittedBox(
                    //     child:
                    //     Text(
                    //       'schedule Delivery',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 13,
                    //           color: colors.primary),
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setSegmentValue(2),
                child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: selectedSegmentVal == 2
                                ? colors.primary
                                : Colors.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Text(
                        'Parcel History',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: colors.primary),
                      ),
                    )
                    // MaterialButton(
                    //   shape: const StadiumBorder(),
                    //   onPressed: () => setSegmentValue(2),
                    //   child: const FittedBox(
                    //     child: Text(
                    //       'Parcel History',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 13,
                    //           color: colors.primary),
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
            ),
          ],
        ),
      );

  setSegmentValue(int i) {
    selectedSegmentVal = i;
    String status;
    if (i == 0) {
      getUserOrderHistory();
      // parcelHistory(2);
    } else if (i == 1) {
      getAcceptedOrder('2');
    } else {
      getAcceptedOrder('4');
      // getParcelHistory();
    }
    setState(() {});
    // getOrderList(status: status);
  }

  Widget activeOrder() {
    return Column(
      children: [
        isLoading2
            ? const Center(child: CircularProgressIndicator())
            : parcelDataList?.data?.isEmpty ?? false
                ? const Center(child: Text('Data Not Available'))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: parcelDataList?.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 2,
                          color: Colors.white,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text("Order Id",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        CustomColors.primary2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                            parcelDataList
                                                    ?.data?[index].orderId ??
                                                '-',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: Row(
                                              children: [
                                                const Text("Phone",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: CustomColors
                                                            .primary2)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                InkWell(
                                                    onTap: () async {
                                                      var url =
                                                          "tel:${parcelDataList?.data?[index].phoneNo}";
                                                      if (await canLaunch(
                                                          url)) {
                                                        await launch(url);
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.local_phone,
                                                      size: 20,
                                                      color:
                                                          CustomColors.primary2,
                                                    )),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      whatsAppLaunch(
                                                          parcelDataList
                                                                  ?.data?[index]
                                                                  .phoneNo ??
                                                              '');
                                                    },
                                                    child: Image.asset(
                                                      'assets/whatsapplogo.webp',
                                                      scale: 45,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(parcelDataList
                                                      ?.data?[index].phoneNo ??
                                                  '-'),
                                              /*const SizedBox(width: 10,),
                                      InkWell(
                                          onTap: () async {
                                            var url = "tel:${parcelDataList?.data?[index].phoneNo}";
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Icon(
                                            Icons.local_phone,
                                            size: 20,
                                            color: CustomColors.primary2,
                                          )),
                                      InkWell(
                                          onTap: () {
                                            whatsAppLaunch(parcelDataList?.data?[index].phoneNo ??'');
                                          },
                                          child: Image.asset(
                                            'assets/whatsapplogo.webp',
                                            scale: 40,
                                          ))*/
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text("Sender Name",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331))),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index].senderName ??
                                              '-'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text("Receiver Name",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331))),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index].senderName ??
                                              '-'),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Sender Address",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFBF2331)),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                                parcelDataList?.data?[index]
                                                        .senderAddress ??
                                                    '-',
                                                overflow: TextOverflow.clip),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Receiver Address",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFBF2331)),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                                parcelDataList?.data?[index]
                                                        .senderAddress ??
                                                    '-',
                                                overflow: TextOverflow.fade,
                                                maxLines: 3),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Date",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFBF2331)),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index].onDate
                                                  .toString()
                                                  .substring(0, 10) ??
                                              '-'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 100,
                                            child: Text(
                                              "Amount",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFFBF2331)),
                                            ),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index].orderAmount ??
                                              '-'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: orderHistoryList[index]
                                                      .isAccepted ??
                                                  false
                                              ? null
                                              : () {
                                                  setState(() {
                                                    orderHistoryList[index]
                                                        .isAccepted = true;
                                                    orderRejectedOrAccept(
                                                        index, context);
                                                  });
                                                },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: orderHistoryList[index]
                                                            .isAccepted ??
                                                        false
                                                    ? Colors.grey
                                                    : Colors.green),
                                            child: Center(
                                              child: Text(
                                                  orderHistoryList[index]
                                                              .isAccepted ??
                                                          false
                                                      ? 'Accepted'
                                                      : 'Accept',
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      orderHistoryList[index].isAccepted ??
                                              false
                                          ? SizedBox.shrink()
                                          : Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  orderRejectedOrAccept(
                                                      index, context,
                                                      isRejected: true);
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.35,
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.red),
                                                  child: const Center(
                                                    child: Text(
                                                      'Reject',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  orderHistoryList[index].isAccepted ?? false
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                //  MaterialPageRoute(builder: (context) => ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails)))
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PercelDetails(
                                                            pId: parcelDataList
                                                                    ?.data?[
                                                                        index]
                                                                    .orderId ??
                                                                ""))).then(
                                                (value) =>
                                                    getAcceptedOrder('2'));
                                          },
                                          child: const Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                'See full details',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors.red),
                                              )),
                                        )
                                      : SizedBox()

                                  /* Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Payment Method",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFFBF2331)),
                                            ),
                                            Text(parcelDataList[index]
                                                .paymentMethod
                                                .toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }

  Widget completeOrder() {
    return Column(
      children: [
        isLoading2
            ? const Center(child: CircularProgressIndicator())
            : parcelDataList?.data?.isEmpty ?? false
                ? const Center(child: Text('Data Not Available'))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: parcelDataList?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      print(
                          '___________${pastParcelDataList.length}__________');

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PercelDetails(
                                        pId: parcelDataList
                                            ?.data?[index].orderId,
                                        isCheck: true,
                                      )));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 2,
                          color: Colors.white,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Text("Parcel ID",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: colors.blackTemp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Text(
                                              "#${parcelDataList?.data?[index].orderId ?? '-'}"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          parcelDataList
                                                      ?.data?[index]
                                                      .parcelDetails
                                                      ?.first
                                                      .status ==
                                                  "4"
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Text("Delivered",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              : Text("Cancel",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Receiver's Name :",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index]
                                                  .parcelDetails
                                                  ?.first
                                                  .receiverName
                                                  .toString() ??
                                              '-'),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Order Date :",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: colors.blackTemp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(parcelDataList
                                                  ?.data?[index].onDate
                                                  .toString()
                                                  .substring(0, 10) ??
                                              '-'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  /*InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails)));
                                },
                                child: const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text('See full details', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),)),
                              )*/

                                  /* Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Payment Method",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              Text(parcelDataList[index]
                                                  .paymentMethod
                                                  .toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
      ],
    );
  }

  void whatsAppLaunch(String num) async {
    var whatsapp = "${num}";
    // var whatsapp = "+919644595859";
    var whatsappURl_android = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Hello, I am messaging from Courier Delivery App, I am interested to pick your parcel, Can we have chat? ";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp does not exist in this device")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Whatsapp does not exist in this device")));
      }
    }
  }

  getAcceptedOrder(String status) async {
    isLoading2 = true;
    setState(() {});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    var headers = {
      'Cookie': 'ci_session=fa3033d7e1f26d8d6379dca4f207a9d5d5606476'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}Payment/get_order_request'));
    request.fields.addAll({'user_id': userId ?? '328', 'status': status});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('_____fffff______${request.fields}__________');
      final result = await response.stream.bytesToString();
      print('___________${result}__________');
      var finalResult = Acceptorder.fromJson(jsonDecode(result));
      isLoading2 = false;
      print("thisi is ============>${finalResult}");
      setState(() {
        parcelDataList = finalResult;
      });
    } else {
      isLoading2 = false;
      print(response.reasonPhrase);
    }
  }

/*  void getParcelHistory() async {
    Api api =Api();
    isLoading3 = true;
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getParcelHistoryData(body);
      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        pastParcelDataList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.status}');
        setState(() {
          isLoading3 = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading3 = false;
    }
  }*/
}
