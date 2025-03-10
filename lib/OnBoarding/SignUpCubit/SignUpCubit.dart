import 'package:chat_application/Models/UserModel.dart';
import 'package:chat_application/OnBoarding/SignUpCubit/SignUpState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Remote/FireBase repo.dart';

class SignUpCubit extends Cubit<SignUpState>{
  FireBaseRepository firebaseRepository;
  SignUpCubit({required this.firebaseRepository}): super(SignUpInitialState());

  void SignUpUser(UserModel user, String pass)async{
    emit(SignUpLoadingState());
    
    try{
      await firebaseRepository.registerUser(user: user, pass: pass);
       emit(SignUpSuccessState());
    }catch(e){
      emit(SignUpFailureState(errorMsg: e.toString()));
    }
    
  }
}