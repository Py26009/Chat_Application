import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/OnBoarding/SIgn%20up%20page.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 80,),
          Text("LOGIN", style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold, color: Colors.red),),
          SizedBox(height: 40,),
          Text(" Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        SizedBox(height: 5,),
        TextField(
          controller:emailController,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.email_outlined),
             // hintText: "Email",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
               borderSide: BorderSide(width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2)
              )
          ),
        ),
        SizedBox(height: 26,),
        Text(" Password",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        TextField(
          controller:passController,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.visibility_off_outlined),
          //    hintText: "Password",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
               borderSide: BorderSide(width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2)
              )
          ),
        ),
        SizedBox(height: 80,),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.redAccent.shade400
          ),
          child: Center(child: Text("LOGIN ",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),)),
        ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New User!!", style: TextStyle(fontSize: 25)),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RepositoryProvider(
                  create: (context)=>FireBaseRepository(),
                child: BlocProvider(
                    create: (context)=>SignUpCubit(firebaseRepository: RepositoryProvider.of<FireBaseRepository>(context)),
                  child: SignUp(),
                ),),)
                );
              }, child: Text("Sign Up", style: TextStyle(fontSize: 25, color: Colors.red),)),
            ],
          )
        ],
      ),),
    );
  }
}
