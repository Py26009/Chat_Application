import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/MessageModel.dart';



class ChatPage extends StatefulWidget {

  String userId;
  String uName;
  String uProfilePic;
 static DateFormat dtFormat = DateFormat.Hm();

 ChatPage({required this.userId, required this.uName, required this.uProfilePic, });

  @override
  State<ChatPage> createState() =>_ChatpageState();
}

class _ChatpageState extends State<ChatPage> {
  List<MessageModel> listMsg = [];
  String fromId = "";
  var msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeChatRoom();
  }
  void initializeChatRoom() async {
    fromId = await FireBaseRepository.getFromId();
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red.shade200,
          body: Column(
      children: [
      Container(
      color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_sharp),
                color: Colors.grey,
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: CircleAvatar(
                  backgroundColor: Colors.yellowAccent.shade200,
                  backgroundImage: widget.uProfilePic != ""
                      ? NetworkImage(widget.uProfilePic)
                      : NetworkImage("https://static.vecteezy.com/system/resources/previews/001/503/756/original/boy-face-avatar-cartoon-free-vector.jpg")
                  as ImageProvider,
                ),
              ),
              SizedBox(
                width: 11,
              ),
              Text(
                widget.uName,
                style: TextStyle(fontSize: 22, color: Colors.white60),
              )
            ],
          ),
        ),
      ),
           Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FireBaseRepository.getChatStream(
                  fromId: fromId, toId: widget.userId),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                         }
                listMsg = List.generate(
                    snapshot.data!.docs.length,
                     (index) => MessageModel.fromDoc(
                          snapshot.data!.docs[index].data()));
      
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return ListView.builder(
                     itemCount: listMsg.length,
              itemBuilder: (_, index) {
                return listMsg[index].fromId == fromId
                       ? userChatBox(listMsg[index])
                       : anotherUserChatBox(listMsg[index], index);
                      });
                   } else {
                 return Center(
                   child: Text(
                    'No Messages yet!,\nstart the conversation today..',
                 style: TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.5)),
              ),
                 );
              }
                 },
              )),
                      SizedBox(
                         height: 7,
                        ),
                     TextField(
                          controller: msgController,
                            enableSuggestions: true,
                        style: TextStyle(fontSize: 16, color: Colors.white60),
                        decoration: InputDecoration(
                        suffixIcon: InkWell(
                         onTap: () {
                            FireBaseRepository.sendTextMessage(
                            toId: widget.userId, msg: msgController.text);
                             msgController.clear();
                           },
                                child: Icon(
                               Icons.send_rounded,
                                 color: Colors.white60,
                                   )),
                              prefixIcon: Icon(
                                Icons.mic,
                               color: Colors.white60,
                                    ),
                              fillColor: Colors.black.withOpacity(0.5),
                             filled: true,
                             hintText: "Write a message!",
                            hintStyle:TextStyle(fontSize: 16, color: Colors.white),
                             border: OutlineInputBorder(
                               borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(11))),
                     ),
                      ],
                        ),
                    ),
    );
                      }

  ///rightSideBox
  Widget userChatBox(MessageModel msgModel) {
    var time = ChatPage.dtFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
                border:
                Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                  bottomLeft: Radius.circular(21),
                )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: msgModel.msgType==0 ? Text(msgModel.msg!,
                      style:TextStyle(fontSize: 16, color: Colors.white)) : msgModel.msg!="" ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(msgModel.imgUrl!),
                      SizedBox(
                        height: 5,
                      ),
                      Text(msgModel.msg!,
                          style: TextStyle(fontSize: 16, color: Colors.white))
                    ],
                  ) : Image.network(msgModel.imgUrl!),),
                SizedBox(
                  width: 11,
                ),
                Icon(
                  Icons.done_all_rounded,
                  color: msgModel.readAt != ""
                      ? Colors.blueAccent
                      : Colors.white.withOpacity(0.5),
                  size: 14,
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: Text(
                      time,
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///leftSideBox
  Widget anotherUserChatBox(MessageModel msgModel, int index) {
    ///update readStatus
    ///

    if(msgModel.readAt==""){
      FireBaseRepository.updateReadStatus(
          msgId: msgModel.msgId!, fromId: fromId, toId: widget.userId);
    }

    var time = ChatPage.dtFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgModel.sentAt!)));

    return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(11),
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  border: Border.all(
                      color:Colors.indigo,
                      width: 2),
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                    bottomRight: Radius.circular(21),
                  )),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: CircleAvatar(
                          backgroundColor:
                          Colors.indigo,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                                backgroundColor: Colors.black,
                                backgroundImage: widget.uProfilePic != ""
                                    ? NetworkImage(widget.uProfilePic)
                                    : NetworkImage("https://static.vecteezy.com/system/resources/previews/001/503/756/original/boy-face-avatar-cartoon-free-vector.jpg")
                                as ImageProvider),
                          )),
                    ),
                  ),
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: msgModel.msgType==0 ? Text(msgModel.msg!,
                              style: TextStyle(fontSize: 16, color: Colors.black)) : Image.network(msgModel.imgUrl!))),
                  Flexible(
                      child: Text(
                        time,
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                ],
              ),
            ),
          ),
        ],
    );
  }
}
