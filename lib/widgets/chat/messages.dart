import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Messages extends StatelessWidget {
  // const Messages({ Key? key }) : super(key: key);
  final Stream<QuerySnapshot> chat = FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots();

  final User? user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chat,
      builder: (
        BuildContext context, 
        AsyncSnapshot<QuerySnapshot> chatSnapshot
      ) {
        if(chatSnapshot.hasError) {
          return const Text('Somthing went wrong.');
        }
          
        if(chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.requireData;

        return FirebaseAuth.instance.currentUser != null 
          ? ListView.builder(
            reverse: true,
            itemCount: chatDocs.size,
            itemBuilder: (ctx, index) => MessageBubble(
              chatDocs.docs[index]['text'],
              chatDocs.docs[index]['userId'],
              chatDocs.docs[index]['userId'] == user?.uid,
              // key: ValueKey(chatDocs.docs[index]['documentID']),
              key: ValueKey(chatDocs.docs[index].id),
            ))
          : const Center(
            child: CircularProgressIndicator() 
          );
          
      }
    );
  }
}