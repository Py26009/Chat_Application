import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/MessageModel.dart';
import '../../Models/UserModel.dart';

class FireBaseRepository{

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Collections
   static const String Collection_User = "Users";
   static const String Collection_chatroom = "Chatroom";
  static const String Collection_messages = "messages";
  static const String PREF_USER_ID_KEY = "userId";

  Future <void> registerUser({required UserModel user, required String pass})async{
     try{
       var userCred = await firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: pass);

       if(userCred.user!=null){
         user.userId = userCred.user!.uid;
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

  Future <void> LoginUser({required String email, required String pass})async{
    try{
      var userCred = await firebaseAuth.signInWithEmailAndPassword(email: email, password: pass);

      if(userCred.user!=null){
        /// add user id in prefs
        var prefs = await SharedPreferences.getInstance();
        prefs.setString(PREF_USER_ID_KEY, userCred.user!.uid);
      }
    }on FirebaseAuthException catch(e){
      throw(Exception("error: Invalid User credentials"));
    }catch(e){
      throw(Exception("error:$e"));
    }
  }

 static Future<QuerySnapshot<Map<String, dynamic>>> getAllContacts(){
    return fireStore.collection(Collection_User).get();
  }

  static Future<String> getFromId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(PREF_USER_ID_KEY)!;
  }

  static String getChatId({required String fromId, required String toId}) {
    if (fromId.hashCode <= toId.hashCode) {
      return "${fromId}_$toId";
    } else {
      return "${toId}_$fromId";
    }
  }

  static sendTextMessage({required String toId, required String msg}) async {
    String fromId = await getFromId();
    var chatId = getChatId(fromId: fromId, toId: toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
      msgId: currTime,
      msg: msg,
      sentAt: currTime,
      fromId: fromId,
      toId: toId,
    );

    fireStore.collection(Collection_chatroom ).doc(chatId).get().then((value) {
      if (value.exists) {
        fireStore
            .collection(Collection_chatroom )
            .doc(chatId)
            .collection(Collection_messages)
            .doc(currTime)
            .set(msgModel.toDoc());
      } else {
        //adding all chat ids in chat document fields
        fireStore.collection(Collection_chatroom ).doc(chatId).set({
          'ids': [fromId, toId]
        }).then((value) => fireStore
            .collection(Collection_chatroom )
            .doc(chatId)
            .collection(Collection_messages)
            .doc(currTime)
            .set(msgModel.toDoc()));
      }
    });
  }

  static sendImageMessage(
      {required String toId, required String imgUrl, String msg = ""}) async {
    String fromId = await getFromId();
    var chatId = await getChatId(fromId: fromId, toId: toId);

    var currTime = DateTime.now().millisecondsSinceEpoch.toString();

    var msgModel = MessageModel(
        msgId: currTime,
        msg: msg,
        sentAt: currTime,
        fromId: fromId,
        toId: toId,
        msgType: 1,
        imgUrl: imgUrl);

    fireStore
        .collection(Collection_chatroom )
        .doc(chatId)
        .collection(Collection_messages)
        .doc(currTime)
        .set(msgModel.toDoc());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(
      {required String fromId, required String toId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);

    return fireStore
        .collection(Collection_chatroom )
        .doc(chatId)
        .collection(Collection_messages)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLiveChatContactStream(
      {required String fromId}) {
    print(fromId);
    return fireStore
        .collection(Collection_chatroom )
        .where("ids", arrayContains: fromId)
        .snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUserId(
      {required String userId}) {
    return fireStore.collection(Collection_User).doc(userId).get();
  }

  static void updateReadStatus(
      {required String msgId, required String fromId, required String toId}) {
    var currTime = DateTime.now().millisecondsSinceEpoch.toString();
    var chatId = getChatId(fromId: fromId, toId: toId);

    fireStore
        .collection(Collection_chatroom )
        .doc(chatId)
        .collection(Collection_messages)
        .doc(msgId)
        .update({"readAt": currTime});
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getLastMsg({required String fromId, required String toId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);

    return fireStore
        .collection(Collection_chatroom )
        .doc(chatId)
        .collection(Collection_messages)
        .orderBy("sentAt", descending: true)
        .limit(1)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getUnReadMsgCount({required String fromId, required String toId}) {
    var chatId = getChatId(fromId: fromId, toId: toId);

    return fireStore
        .collection(Collection_chatroom )
        .doc(chatId)
        .collection(Collection_messages)
        .where("readAt", isEqualTo: "")
        .where("fromId", isEqualTo: toId)
        .snapshots();
  }
}

