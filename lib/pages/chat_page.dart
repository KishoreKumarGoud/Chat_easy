import 'package:chat_easy/models/messages.dart';
import 'package:chat_easy/models/user_profile.dart';
import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {

  final UserProfile chatUser;
  const ChatPage({super.key,
  required this.chatUser,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser?currentUser,otherUser;
  late AuthService _authService;
  late Databaseservice _databaseservice;
  final GetIt _getIt=GetIt.instance;
  @override
  void initState()
  {
    super.initState();
    _authService=_getIt.get<AuthService>();
    late Databaseservice  _databaseService;
    currentUser=ChatUser(id: _authService.user!.uid,firstName: _authService.user!.displayName,);
    otherUser=ChatUser(id: widget.chatUser.uid!,firstName: widget.chatUser.name,profileImage: widget.chatUser.pfpURL,);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.chatUser.name!,
      ),
      ),
      body:_buildUI(),
    );
  }
  Widget _buildUI(){
    return DashChat(
      messageOptions: const MessageOptions(
        showOtherUsersAvatar: true,
        showTime: true,
      ),
      inputOptions: const InputOptions(alwaysShowSend: true,
      ),
      currentUser: currentUser!,
       onSend: _sendMessage, 
       messages: [],
       );
  }
  Future<void> _sendMessage(ChatMessage ChatMessage) async
  {
Message message=Message(senderID: currentUser!.id,
 content: ChatMessage.text, 
messageType: MessageType.Text, 
sentAt: Timestamp.fromDate(ChatMessage.createdAt),
);
await _databaseservice.sendChatMessage(currentUser!.id,otherUser!.id,message);
  }
}
