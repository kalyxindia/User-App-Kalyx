import 'dart:async';

import 'package:flutter/material.dart';
import 'package:userapp/mainScreens/main_screen.dart';

import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/global.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  
  startTimer(){

   firebaseAuth.currentUser!=null ? AssistantMethods.readCurrentOnlineUserInfo() : null;

    Timer(const Duration(seconds: 3),() async {

      if(await firebaseAuth.currentUser !=null )
      {
        Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
      }else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/car.png"),
            const Text(
                "Keyfob User App",
              style:TextStyle(
                fontSize:  20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              )
            )
          ],
        ),
      ),
    );
  }
}
