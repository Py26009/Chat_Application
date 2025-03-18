import 'package:chat_application/Data/Remote/FireBase%20repo.dart';
import 'package:chat_application/Models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ChatPage.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String fromId = "";

  @override
  void initState() {
    super.initState();
    getFromId();
  }

  void getFromId() async {
    fromId = await FireBaseRepository.getFromId();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      appBar: AppBar(
        title: Text("All Contacts"),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FireBaseRepository.getAllContacts(),
          builder: (_,snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshots.hasError){
              return Center(
                child: Text(snapshots.error.toString()),
              );
            }else if(snapshots.hasData){
              return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                  itemBuilder: (_,index){
                  var NewModel = UserModel.fromDoc(snapshots.data!.docs[index].data());
                         return Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Card(child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ListTile(
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                       builder: (context) =>
                                           ChatPage(
                                               userId: NewModel.userId!,
                                               uName: NewModel.name!,
                                               uProfilePic: NewModel.profilePic!),
                                     ));
                               },
                               leading: CircleAvatar(
                                 maxRadius: 24,
                                 backgroundImage: NewModel.profilePic!="" ? NetworkImage(NewModel.profilePic!):NetworkImage("https://static.vecteezy.com/system/resources/previews/001/503/756/original/boy-face-avatar-cartoon-free-vector.jpg")as ImageProvider ,
                               ),
                               subtitle: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(NewModel.name!),
                                   Text(NewModel.mobNo!)
                                 ],
                               ),
                             ),
                           )),
                         );
              });
            }
            return Container();
          }),
    );
  }
}
