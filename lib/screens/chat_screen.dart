import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // const ChatScreen({ Key? key }) : super(key: key);
  @override
  void initState() {
    super.initState();
    final FirebaseMessaging _fbm = FirebaseMessaging.instance;
    _fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) { 
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) { 
      print(message);
      return;
    });

    _fbm.subscribeToTopic('chat');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: const Icon(
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