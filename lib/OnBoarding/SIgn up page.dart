import 'package:chat_application/Models/UserModel.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpCubit.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {

  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {

 TextEditingController nameController = TextEditingController();
 TextEditingController phoneController = TextEditingController();
 TextEditingController emailController = TextEditingController();
 TextEditingController passController = TextEditingController();
 TextEditingController genderController = TextEditingController();
// String defaultGender = "Male";
  bool isPassVisible = false;

  GlobalKey<FormState> mKey = GlobalKey<FormState>();

  bool isEmailValid({required String email}){
    RegExp regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(email);
  }

  bool isPassValid({required String pass}){
    RegExp regExp1 = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
    return regExp1.hasMatch(pass);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              Text("SIGN UP",style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.red) ),
              SizedBox(height: 30,),
              Text(" Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              SizedBox(
                child: TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return message();
                    }else{
                      return null;
                    }
                  },
                  controller:nameController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red, width: 2)
                    )
                  ),
                ),
              ),
              SizedBox(height: 21,),
              Text("Gender",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return message();
                  }else if(value== "Male" || value =="Female" || value=="Others"){
                    return null;
                  }else{
                    return "Please enter any one from these: Male, Female or Others";
                  }
                },
                controller:genderController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.man),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                ),
              ),
              SizedBox(height: 21,),
              Text("Phone",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return message();
                  }else if(value.length!=10){
                    return "Please enter a valid number";
                  }else{
                    return null;
                  }
                },
                controller:phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.phone),
                 //   hintText: "Phone",
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2,
                          color: Colors.red,
                    ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2, color: Colors.red
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 2
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    )
                ),
              ),
              SizedBox(height: 16,),
              Text("Email",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5,),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return message();
                  }else if(isEmailValid(email: value)){
                    return "Please enter a valid email";
                  }else{
                    return null;
                  }
                },
                controller:emailController,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2)
                    ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red, width: 2)
                  )
                ),
              ),
              SizedBox(height: 16,),
              Text("Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return message();
                  }else if(isPassValid(pass: value)){
                    return "Please enter a password";
                  }else{
                    return null;
                  }
                },
                controller:passController,
                obscureText: !isPassVisible,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: (){
                          isPassVisible =!isPassVisible;
                          setState(() {
        
                          });
                      },
                        child: Icon(isPassVisible ? Icons.visibility_outlined: Icons.visibility_off_outlined)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            width: 2
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 80,),
              BlocConsumer<SignUpCubit, SignUpState>(
                  builder: (_, state){
                    if(state is SignUpLoadingState){
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
                            Text("Registering User",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
                          ],
                        ),)
                      );
                    }
                    return InkWell(
                      onTap: ()async{
                        if(mKey.currentState!.validate()){
                          String email = emailController.text;
                          String pass = passController.text;
        
                          if(emailController.text.isNotEmpty
                              && passController.text.isNotEmpty
                              && genderController.text.isNotEmpty
                              && nameController.text.isNotEmpty
                              && phoneController.text.isNotEmpty){
                            var newUser = UserModel(
                                name: nameController.text,
                                status: 1,
                                email: email,
                                mobNo: phoneController.text,
                                userId: "userId",
                                gender: genderController.text,
                                createdAt:DateTime.now().millisecondsSinceEpoch.toString() ,
                                isOnline: false,
                                profilePic: "",
                                profileStatus: 1);
        
                            BlocProvider.of<SignUpCubit>(context).firebaseRepository.registerUser(user: newUser, pass: pass);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text("SIGN UP",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),)),
                      ),
                    );
                  },
                  listener: (_, state){
                    if(state is SignUpFailureState){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMsg, style: TextStyle(fontSize: 16),)));
                    }else if(state is SignUpSuccessState){
                          Navigator.pop(context);
                    }
                  }),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a User!!", style: TextStyle(fontSize: 22),),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Login", style: TextStyle(fontSize: 22,color: Colors.red),))
                ],
              )
        
            ],
          ),
        ),
      ),
    );
  }
}

 String message(){
  return "This field is mandatory";
 }
