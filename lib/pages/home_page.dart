import 'package:chat_easy/models/user_profile.dart';
import 'package:chat_easy/pages/chat_page.dart';
import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/services/database_service.dart';
import 'package:chat_easy/services/navigation_services.dart';
import 'package:chat_easy/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt=GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late Databaseservice _databaseservice;
  void initState()
  {
    super.initState();
    _authService=_getIt.get<AuthService>();
    _navigationService=_getIt.get<NavigationService>();
    _databaseservice=_getIt.get<Databaseservice>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title :const Text(
          "Messages",
        ),
        actions: [
          IconButton(
            onPressed: () async { //to make sure user is logout and again if he open he looks at login page only
              bool result =await _authService.logout();
              if(result)
              {
                _navigationService.pushReplacementNamed("/login");
              }
            }, 
          color: Colors.red,
          icon: const Icon(
            Icons.logout,
          ))
        ],
      ),
      body: _buildUI(),
    );
  }
  Widget _buildUI()
  {
    return SafeArea(child: Padding(padding: const EdgeInsets.symmetric(
      horizontal: 15.0,
      vertical: 20.0
    ),
    child: _chatsList(),
    ),
    );
  }
  Widget _chatsList()
  {
return StreamBuilder(
  stream:_databaseservice.getUserProfiles(), 
  builder: (context,snapshot) {
  if(snapshot.hasError)
  {
    return const Center(
      child: Text("Unable to load data"),
    );
  }
  print(snapshot.data);
  if(snapshot.hasData && snapshot.data!=null)
  {
    final users=snapshot.data!.docs;
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context,index){
        UserProfile user=users[index].data();
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0),
          child: ChatTile(

            userProfile: user, 
          onTap: () async {
            final chatExists=await _databaseservice.checkChatExists(_authService.user!.uid, user.uid!);
            if(!chatExists)
            {
              await _databaseservice.createNewChat(_authService.user!.uid, user.uid!);
            }
            _navigationService.push(MaterialPageRoute(builder: (context){

            return ChatPage(chatUser: user,
            );
          },
          ),
          );
          },
          ),
        );
      });
  }
  return const Center(
    child:CircularProgressIndicator(),
  );
}); 
  }
}