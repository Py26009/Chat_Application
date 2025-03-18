import 'dart:async';

import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/OnBoarding/Login%20page.dart';
import 'package:chat_application/OnBoarding/SIgn%20up%20page.dart';
import 'package:chat_application/Screens/Messages%20page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), ()async{

      /// Check Session
      var prefs = await SharedPreferences.getInstance();
      String ? value = prefs.getString(FireBaseRepository.PREF_USER_ID_KEY);

      Widget nextPage = LoginPage();

      if(value!=null && value!= ""){
        nextPage = AllMessagesPage();
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>nextPage));
    });
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 300,
            width: 200,
            ),
          Center(child: ClipOval(child: Image.network('https://th.bing.com/th/id/OIP.UYnBJR0B6MYZ9o-zaDmf8gHaFj?w=640&h=480&rs=1&pid=ImgDetMain',height: 100, width: 100, fit: BoxFit.cover,))),
          SizedBox(
            height: 30,
          ),
          Text("Let's Chat", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),)
        ],
      ),
    );

  }
}
