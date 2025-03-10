abstract class SignUpState{}

class SignUpInitialState extends SignUpState{}
class SignUpLoadingState extends SignUpState{}
class SignUpSuccessState extends SignUpState{}
class SignUpFailureState extends SignUpState{
  String errorMsg;
  SignUpFailureState({required this.errorMsg});
}


