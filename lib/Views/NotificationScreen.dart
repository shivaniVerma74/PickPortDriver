import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/notification_response.dart';
import '../Utils/Color.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  Api api = Api();

  List<NotificationDataList> notificationList = [];

  @override
  void initState() {
    // TODO: implement initState
    getNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 70,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            height: 40,
            width: 40,
            decoration:
            BoxDecoration(color: colors.whiteTemp, shape: BoxShape.circle),
            child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
        ),

        title: Text(
          'Notification',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),

        actions: [
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SupportNewScreen()));
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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 20,
          ),
          // Expanded(
          //   flex: 2,
          //   child:
          //   // Padding(
          //   //   padding: const EdgeInsets.only(left: 20, right: 20),
          //   //   child: Row(
          //   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   //     children: [
          //   //       InkWell(
          //   //         onTap: () {
          //   //           Navigator.pop(context);
          //   //         },
          //   //         child: Container(
          //   //           height: 40,
          //   //           width: 40,
          //   //           decoration: BoxDecoration(
          //   //               color: colors.whiteTemp,
          //   //               borderRadius: BorderRadius.circular(100)),
          //   //           child: Center(child: Icon(Icons.arrow_back)),
          //   //         ),
          //   //       ),

          //   //       // Container(
          //   //       //   height: 40,
          //   //       //   width: 40,
          //   //       //   decoration:  BoxDecoration(
          //   //       //       color: splashcolor,
          //   //       //       borderRadius:
          //   //       //       BorderRadius.circular(100)),
          //   //       //   child: InkWell(
          //   //       //       onTap: () {
          //   //       //         Navigator.push(
          //   //       //             context,
          //   //       //             MaterialPageRoute(
          //   //       //                 builder: (context) =>
          //   //       //                 const NotificationScreen()));
          //   //       //       },
          //   //       //       child: Center(
          //   //       //         child: Image.asset(
          //   //       //           'assets/ProfileAssets/support.png',scale: 1.3,
          //   //       //         ),
          //   //       //       )),
          //   //       // ),
          //   //     ],
          //   //   ),
          //   // ),
          // ),
          Expanded(
            // flex: 11,
            child: Container(
              decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: double.maxFinite,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : notificationList.isEmpty
                      ? Center(child: const Text('Data Not Available'))
                      : ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: false,
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {},
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Id:               ',
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                        Text(notificationList[index]
                                            .id ??
                                            '')
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Date:           ',
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                        Text(notificationList[index]
                                            .date ??
                                            '')
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Message:',
                                          style: TextStyle(
                                              color: Colors.red),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                            width: 200,
                                            child: Text(
                                                notificationList[index]
                                                    .notification ??
                                                    ''))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      }),
                ),
              ),
            ),
          )
        ],
      ),

      // body: Column(
      //   children: [
      //     Row(
      //       children: [
      //         Text("${Contact!.data!.pgDescri}"),
      //       ],
      //     ),
      //
      //     // Image.asset("assets/ContactUsAssets/contactusIcon.png",scale: 1.2,),
      //     // SizedBox(height: 30,),
      //     // Text("Incase of any queries or assistance\nKindly what's app us", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Lora'),textAlign: TextAlign.center,),
      //     // SizedBox(height: 30,),
      //     // Padding(padding: EdgeInsets.symmetric(horizontal: 30),
      //     // child: Column(
      //     //   children: [
      //     //     // Html(data: "${Contact!.data!.pgDescri}", imageIcon: Image.asset('assets/ContactUsAssets/call.png', scale: 1.9,));
      //     //     LogoWithText(labelText: "810 810 3355", imageIcon: Image.asset('assets/ContactUsAssets/call.png', scale: 1.9,)),
      //     //     LogoWithText(labelText: "810 810 3355", imageIcon: Image.asset('assets/ContactUsAssets/whatsapp.png', scale: 1.9,),),
      //     //
      //     //     // LogoWithText(labelText: "${Contact!.data!.pgDescri}", imageIcon: Image.asset('assets/ContactUsAssets/email.png', scale: 1.2,)),
      //     //     // LogoWithText(labelText: "@jdxconnectofficial", imageIcon: Image.asset('assets/ContactUsAssets/instagram.png', scale: 1.2,)),
      //     //     // LogoWithText(labelText: "@jdxconnct_official", imageIcon: Image.asset('assets/ContactUsAssets/facebook.png', scale: 1.2,))
      //     //   ],
      //     // ),)
      //   ],
      //
      // )
    );

    //   Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Color(0xFF222443),
    //     /*leading: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Container(
    //           height: 23,
    //           width: 23,
    //           decoration: BoxDecoration(
    //               color: Colors.white, borderRadius: BorderRadius.circular(30)),
    //           child: const Icon(
    //             Icons.arrow_back,
    //             color: Colors.black,
    //           )),
    //     ),*/
    //     title: const Text('Notification'),
    //   ),
    //   body: SingleChildScrollView(
    //     padding: const EdgeInsets.all(15),
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: MediaQuery.of(context).size.height,
    //           width: double.maxFinite,
    //           child: isLoading
    //               ? const Center(child: CircularProgressIndicator())
    //               : notificationList.isEmpty
    //                   ? const Text('Data Not Available')
    //                   : ListView.builder(
    //                       scrollDirection: Axis.vertical,
    //                       physics: const NeverScrollableScrollPhysics(),
    //                       shrinkWrap: false,
    //                       itemCount: notificationList.length,
    //                       itemBuilder: (context, index) {
    //                         return InkWell(
    //                           onTap: () {},
    //                           child: Card(
    //                             child: Container(
    //                               padding: const EdgeInsets.all(10),
    //                               child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                               Row(children: [
    //                                 const Text('Id:               ',  style: TextStyle(color: Colors.red),),
    //                                 Text(notificationList[index].id ?? '')
    //                               ],),
    //                                 const SizedBox(height: 20,),
    //                                 Row(children: [
    //                                   const Text('Date:           ',  style: TextStyle(color: Colors.red),),
    //                                   Text(notificationList[index].date ?? '')
    //                                 ],),
    //                                 const SizedBox(height: 20,),
    //                                 Row(children: [
    //                                   const Text('Message:',  style: TextStyle(color: Colors.red),),
    //                                   const SizedBox(width: 10,),
    //                                   SizedBox(
    //                                     width: 200,
    //                                       child: Text(notificationList[index].notification ?? ''))
    //                                 ],),
    //                           ],),
    //                             ),)
    //                         );
    //                       }),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  void getNotificationList() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getNotificationData(body);
      if (res.status ?? false) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        notificationList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading = false;
    }
  }
}
