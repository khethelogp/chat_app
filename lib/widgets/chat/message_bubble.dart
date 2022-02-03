import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  // const MessageBubble({ Key? key }) : super(key: key);
  MessageBubble(
    this.message, 
    this.userName,
    this.isMe,
    {required this.key}
  );

  final Key key;
  final String message;
  final String userName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ?  Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12)
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(
            vertical:10, 
            horizontal: 16
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe? Colors.black : Theme.of(context).accentTextTheme.headline1?.color
                  ),
              ),
              
              Text(
                message,
                style: TextStyle(
                  color: isMe? Colors.black : Theme.of(context).accentTextTheme.headline1?.color
                ),
                textAlign: isMe? TextAlign.end :  TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}