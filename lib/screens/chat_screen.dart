import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  // const ChatScreen({ Key? key }) : super(key: key);
  // final Stream<QuerySnapshot> chats = FirebaseFirestore.instance.collection('chats/lrnb5C09ur3xozmJUVk4/messages').snapshots();
  
  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert, 
              color: Colors.white,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8,),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ], 
            onChanged: (itemIdentifier) {
              if(itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            }
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages()
            ),
            NewMessage()
          ],
        )
      ),
    );
  }
}