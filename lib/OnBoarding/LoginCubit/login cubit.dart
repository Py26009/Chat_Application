import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/OnBoarding/LoginCubit/login%20state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState>{
  FireBaseRepository fireBaseRepository;
  LoginCubit({required this.fireBaseRepository}): super(LoginInitialState());


  void AuthenticateUser({required String email, required String pass})async{
    emit(LoginLoadingState());

    try{
      await  fireBaseRepository.LoginUser(email: email, pass: pass);
        emit(LoginSuccessState());
    }catch (e){
      emit(LoginFailureState(errorMsg: e.toString()));
    }
  }
}