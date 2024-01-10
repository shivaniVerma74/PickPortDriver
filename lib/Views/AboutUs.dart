import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jdx/Utils/ApiPath.dart';
import '../Models/privacypolicymodel.dart';
import '../Utils/AppBar.dart';
import '../Utils/Color.dart';
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrivacy();
  }

  var privacyData;

  PrivacypolicyModel? privacypolicy;

  getPrivacy() async {
    var headers = {
      'Cookie': 'ci_session=e27b9a709e79f067f9b5f2e6f6541ff1595521a5'
    };
    var request =
    http.MultipartRequest('GET', Uri.parse('${Urls.baseUrl}users/Privacy'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      var jsonResponse = PrivacypolicyModel.fromJson(jsonDecode(finalResponse));
      setState(() {
        privacyData = jsonResponse.data;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: colors.whiteTemp,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: commonAppBar(context, text: "About Us")),
            body: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: const BoxDecoration(

                ),
                child: privacyData == null || privacyData == ""
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: const BoxDecoration(
                      borderRadius:
                      BorderRadius.only(topRight: Radius.circular(0)),
                      color: Colors.white),
                  width: size.width,
                  height: size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Html(data: "${privacyData}"),
                        Text(
                          '${privacyData?.pgDescri}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
