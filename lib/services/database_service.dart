// ignore_for_file: unused_local_variable

import 'package:chat_easy/models/chats.dart';
import 'package:chat_easy/models/messages.dart';
import 'package:chat_easy/models/user_profile.dart';
import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class Databaseservice
{
  final GetIt _getIt=GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _userCollection;
    CollectionReference? _chatsCollection;
    late Databaseservice _databaseservice;

  

  late AuthService _authService;

  Databaseservice()
  {
    _authService=_getIt.get<AuthService>();
    _setupCollectionReferences();
  }
    
      get docRef => null;
    
    
    void _setupCollectionReferences()
    {
      _userCollection=_firebaseFirestore.collection('users').withConverter<UserProfile>(
        fromFirestore:(snapshot,_) =>UserProfile.fromJson(snapshot.data()!,
        ),
     
      toFirestore: (userProfile, _)=>userProfile.toJson(),
      );
      _chatsCollection=_firebaseFirestore.collection('chats').withConverter<Chat>(fromFirestore: (snapshots,_)=> Chat.fromJson(snapshots.data()!),toFirestore: (chat,_)=>chat.toJson(),);
      

    }
    Future<void> createUserProfile({required UserProfile userProfile}) async
    {
          await _userCollection?.doc(userProfile.uid).set(userProfile);
    }
    Stream <QuerySnapshot<UserProfile>>getUserProfiles()
    {
     return  _userCollection?.where("uid",isNotEqualTo: _authService.user!.uid)
      .snapshots() as Stream<QuerySnapshot<UserProfile>>;
    }
    Future<bool> checkChatExists(String uid1,String uid2) async{
      String chatID=await generateChatID(uid1: uid1, uid2: uid2);
      final result=await _chatsCollection?.doc(chatID).get();
      if(result!=null)
      {
        return result.exists;
      }
      return false;


    }
    Future<void>createNewChat(String uid1,String uid2) async{
      String chatID = generateChatID(uid1: uid1, uid2: uid2) as String;
      // ignore: duplicate_ignore
      // ignore: unused_local_variable
      final docref=_chatsCollection!.doc(chatID as String?);
      final chat=Chat(
        id: chatID,
        participants: [uid1,uid2],
        messages: [],
        );
      await docRef.set(chat);
    }
    Future<void>sendChatMessage(String uid1,String uid2,Message message)async
    {
            String chatID = generateChatID(uid1: uid1, uid2: uid2) as String;
                  final docref=_chatsCollection!.doc(chatID as String?);
                  await docref.update({
                    "messages":FieldValue.arrayUnion([message.toJson(),],),
                  });


    }
}