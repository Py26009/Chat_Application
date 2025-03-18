import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/MessageModel.dart';
import '../Models/UserModel.dart';
import '../OnBoarding/Login page.dart';
import 'ChatPage.dart';
import 'Contacts Page.dart';



DateFormat dtFormat = DateFormat.Hm();
class AllMessagesPage extends StatefulWidget {

  @override
  State<AllMessagesPage> createState() => _AllMessagesPageState();
}

class _AllMessagesPageState extends State<AllMessagesPage> {
  String fromId = "";

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  void getFromId() async {
    fromId = await FireBaseRepository.getFromId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 22, color: Colors.black38),
        ),
        actions: [
          PopupMenuButton(
              child: Icon(Icons.more_vert_outlined),
              itemBuilder: (_) {
                return [
                  PopupMenuItem(
                      onTap: () async {
                        /// session out
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString(
                          FireBaseRepository.PREF_USER_ID_KEY, "");

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      child: Text('Logout')),
                ];
              })
        ],
      ),
      body: StreamBuilder(
        stream: FireBaseRepository.getLiveChatContactStream(fromId: fromId),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshots.hasError) {
            return Center(
              child: Text(snapshots.error.toString()),
            );
          } else if (snapshots.hasData) {
            var listUserId =
            List.generate(snapshots.data!.docs.length, (index) {
              var mData =
              snapshots.data!.docs[index].get('ids') as List<dynamic>;
              mData.removeWhere((element) => element == fromId);
              return mData[0];
            });

            print(listUserId);

            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
              child: ListView.builder(
                  itemCount: listUserId.length,
                  itemBuilder: (_, index) {
                    return FutureBuilder(
                        future: FireBaseRepository.getUserByUserId(
                            userId: listUserId[index]),
                        builder: (_, userSnap) {
                          if (userSnap.hasData) {
                            var currModel =
                            UserModel.fromDoc(userSnap.data!.data()!);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            userId: currModel.userId!,
                                            uName: currModel.name!,
                                            uProfilePic: currModel.profilePic!),
                                      ));
                                },
                                child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                         Colors.pink.shade100,
                                          radius: 25,
                                          backgroundImage: currModel
                                              .profilePic !=
                                              ""
                                              ? NetworkImage(
                                              currModel.profilePic!)
                                              : AssetImage(
                                              'assets/images/ic_user.png')
                                          as ImageProvider,
                                        ),
                                        title: Text(
                                          currModel.name!,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        subtitle: StreamBuilder(
                                          stream: FireBaseRepository.getLastMsg(
                                              fromId: fromId,
                                              toId: currModel.userId!),
                                          builder: (_, lastMsgSnapshots) {
                                            if (lastMsgSnapshots.hasData) {
                                              var lastMsg =
                                              MessageModel.fromDoc(
                                                  lastMsgSnapshots
                                                      .data!.docs[0]
                                                      .data());
                                              return lastMsg.fromId == fromId
                                                  ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .done_all_rounded,
                                                    color: lastMsg
                                                        .readAt !=
                                                        ""
                                                        ? Colors.lightBlueAccent
                                                        : Colors.white
                                                        .withOpacity(
                                                        0.5),
                                                    size: 14,
                                                  ),
                                                  lastMsg.msgType == 0
                                                      ? Text(
                                                    lastMsg.msg!,
                                                    style:TextStyle(fontSize: 16, color: Colors.grey)
                                                  )
                                                      : lastMsg.msg != ""
                                                      ? Row(
                                                    children: [
                                                      Icon(
                                                        Icons.image,
                                                        color: Colors.lightBlueAccent,
                                                        size:
                                                        14,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                          lastMsg.msg!,
                                                          style:
                                                          TextStyle(fontSize: 12, color: Colors.grey))
                                                    ],
                                                  )
                                                      : Row(
                                                    children: [
                                                      Icon(
                                                        Icons.image,
                                                        color:Colors.lightBlueAccent,
                                                        size: 14,
                                                      ),
                                                      SizedBox(width: 5,),
                                                      Text(
                                                          'sent a photo',
                                                          style:
                                                          TextStyle(fontSize: 12, color: Colors.grey))
                                                    ],
                                                  ),
                                                ],
                                              )
                                                  : lastMsg.msgType == 0
                                                  ? Text(
                                                lastMsg.msg!,
                                                style: TextStyle(fontSize: 12, color: Colors.grey)
                                              )
                                                  : lastMsg.msg != ""
                                                  ? Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .image,
                                                    color: Colors.lightBlueAccent,
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text(
                                                      lastMsg
                                                          .msg!,
                                                      style:
                                                      TextStyle(fontSize: 12, color: Colors.grey))
                                                ],
                                              )
                                                  : Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .image,
                                                    color: Colors.lightBlueAccent,
                                                    size: 14,
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text(
                                                      'sent a photo',
                                                      style:
                                                      TextStyle(fontSize: 12, color: Colors.grey))
                                                ],
                                              );
                                            }

                                            return Text(
                                              currModel.email!,
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            );
                                          },
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            StreamBuilder(
                                                stream: FireBaseRepository
                                                    .getLastMsg(
                                                    fromId: fromId,
                                                    toId:
                                                    currModel.userId!),
                                                builder: (_, lastMsgTimeSnap) {

                                                  if (lastMsgTimeSnap.hasData) {
                                                    var lastMsg =
                                                    MessageModel.fromDoc(
                                                        lastMsgTimeSnap
                                                            .data!.docs[0]
                                                            .data());
                                                    var time = dtFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(lastMsg.sentAt!)));
                                                    return Text(
                                                      time,
                                                      style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                            StreamBuilder(
                                                stream:FireBaseRepository
                                                    .getUnReadMsgCount(
                                                    fromId: fromId,
                                                    toId:
                                                    currModel.userId!),
                                                builder: (_,
                                                    unReadMsgCountSnapshot) {
                                                  if (unReadMsgCountSnapshot
                                                      .hasData &&
                                                      unReadMsgCountSnapshot
                                                          .data!
                                                          .docs
                                                          .isNotEmpty) {
                                                    return CircleAvatar(
                                                      radius: 10,
                                                      child: Text(
                                                        '${unReadMsgCountSnapshot.data!.docs.length}',
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                    );
                                                  }
                                                  return SizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  );
                                                })
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          }
                          return Container();
                        });
                  }),
            );
          }

          /* return ListView.builder(
              itemCount: listContact.length,
              itemBuilder: (_, index) {
                var currModel = listContact[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11.0),
                  child: Card(
                      color: AppColors.mediumBlack,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                      userId: currModel.userId!,
                                      uName: currModel.name!,
                                      uProfilePic: currModel.profilePic!),
                                ));
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondaryYellowColor,
                            radius: 25,
                            backgroundImage: currModel.profilePic != ""
                                ? NetworkImage(currModel.profilePic!)
                                : AssetImage('assets/images/ic_user.png')
                            as ImageProvider,
                          ),
                          title: Text(
                            currModel.name!,
                            style: mTextStyle16(
                                mColor: Colors.grey,
                                mFontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            currModel.email!,
                            style: mTextStyle12(mColor: Colors.grey),
                          ),
                        ),
                      )),
                );
              });*/

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactsPage(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
