import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Models/UserModel.dart';

class FireBaseRepository{

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Collections
   static const String Collection_User = "Users";
   static const String Collection_chatroom = "Chatroom";

  Future <void> registerUser({required UserModel user, required String pass})async{
     try{
       var userCred = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: pass);

       if(userCred.user!=null){
                 fireStore
                .collection(Collection_User)
                .doc(userCred.user!.uid)
                .set(user.toDoc())
                .catchError((error){
                  throw(Exception("error:$error"));
            });

       }
     }on FirebaseAuthException catch(e){
       throw(Exception("error:$e"));
     }catch(e){
       throw(Exception("error:$e"));
     }
   }
}