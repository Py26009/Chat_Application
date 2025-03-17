import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/OnBoarding/LoginCubit/login%20cubit.dart';
import 'package:chat_application/OnBoarding/LoginCubit/login%20state.dart';
import 'package:chat_application/OnBoarding/SIgn%20up%20page.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Screens/Messages page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> mKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(8.0),
        child: Form(
          key: mKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80,),
              Text("LOGIN", style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold, color: Colors.red),),
              SizedBox(height: 40,),
              Text(" Email", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            TextFormField(
              validator: (value) {
                const pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                final regExp = RegExp(pattern);
                if (value == null || value.isEmpty) {
                  return "This field is mandatory";
                } else if(!regExp.hasMatch(value)){
                     return "Invalid Email";
                } else {
                  return null;
                }
              },
              controller:emailController,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                   borderSide: BorderSide(width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2)
                  ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 2, color: Colors.red)
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 2, color: Colors.red)
                ),
              ),
            ),
            SizedBox(height: 26,),
            Text(" Password",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            TextFormField(
              validator: (value){
                if (value == null || value.isEmpty) {
                  return "This field is mandatory";
                }else{
                  return null;
                }
              },
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
                  ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 2, color: Colors.red)
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 2, color: Colors.red)
                ),
              ),
              ),
            SizedBox(height: 80,),
        
           BlocConsumer<LoginCubit, LoginState>(builder: (_,state){
             if(state is LoginLoadingState){
               return InkWell(
                   onTap: (){},
                   child: Container(height: 50,
                     decoration: BoxDecoration(
                       color: Colors.redAccent.shade400,
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: CircularProgressIndicator(),
                         ),
                         SizedBox(width: 5,),
                         Text("Authenticating User",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                       ],
                     ),)
               );
             }
             return  Container(
               height: 50,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(12),
                   color: Colors.redAccent.shade400
               ),
               child: InkWell(
                   onTap: ()async{
        
                     /// FireBase Login
                     if(mKey.currentState!.validate()){
                       String email = emailController.text;
                       String pass = passController.text;
        
                       BlocProvider.of<LoginCubit>(context).AuthenticateUser(email: email, pass: pass);
                     }
                     },
                   child: Center(child: Text("LOGIN ",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),))),
             );
           }, listener: (_, state){
                           if (!mounted) return;
                            if(state is LoginFailureState){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg, style: TextStyle(fontSize: 16),)));
                         }else if(state is LoginSuccessState){
                         Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> AllMessagesPage()));
                }
           }),
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
          ),
        ),),
      ),
    );
  }
}
