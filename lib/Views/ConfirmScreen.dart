import 'package:flutter/material.dart';
import 'package:jdx/Views/HomeScreen.dart';

import '../Utils/Color.dart';

class ConfimeScreen extends StatefulWidget {
  const ConfimeScreen({Key? key}) : super(key: key);

  @override
  State<ConfimeScreen> createState() => _ConfimeScreenState();
}

class _ConfimeScreenState extends State<ConfimeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120,),
               Image.asset("assets/images/comple.png",scale: 1.3,),
              SizedBox(height: 30,),
              Center(child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since")),
              SizedBox(height: 30,),
              InkWell(
                onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colors.primary
                  ),
                  child: Center(child: Text("Completed",style: TextStyle(fontSize: 15,color: colors.whiteTemp),)),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
