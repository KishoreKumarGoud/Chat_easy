// ignore_for_file: dead_code

import 'dart:io';

import 'package:chat_easy/models/user_profile.dart';
import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/services/database_service.dart';
import 'package:chat_easy/services/media_service.dart';
import 'package:chat_easy/services/navigation_services.dart';
import 'package:chat_easy/services/stortage_services.dart';
import 'package:chat_easy/widgets/consts.dart';
import 'package:chat_easy/widgets/custom_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthService _authService;
  final GetIt _getIt=GetIt.instance;
  late MediaService _mediaService;
  File? selectedImage;
  late StortageServices _stortageServices;
  late Databaseservice _databaseservice;
 
  
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late NavigationService _navigationService;
   String? email, password, name;
   bool isLoading=false;
 
  @override
  void initState()
  {
    
      super.initState();
      _mediaService=_getIt.get<MediaService>();
      _navigationService=_getIt.get<NavigationService>();
      _authService=_getIt.get<AuthService>();
      _stortageServices=_getIt.get<StortageServices>();
      _databaseservice=_getIt.get<Databaseservice>();



    }
  
  Widget build(BuildContext context) {
      return Scaffold(
      
      resizeToAvoidBottomInset: false,
      body:_buildUI(),
    );
  }
  Widget _buildUI()  
  {
    return SafeArea(
      child:Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child:Column(
          children: [
            _headerText(),
           if(!isLoading) _registerForm(),
             if(!isLoading) _loginAccountLink(),
             if(isLoading) const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
             ),
             ),
             ],
        ),
  
      ),
      
    );
  }
   Widget  _headerText()
  {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Text(
            "Hey! wassup,register below and become a member..",
            style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800),
          ),
        ],
      
      ),
    );

  }
  Widget _registerForm()
  {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.60,
      margin:EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05,),
    child: Form(
      key: _registerFormKey,
      child: Column(
      children: <Widget>[
   _pfpSelectionFiled(),
   CustomFormField(hintText: "Name", height:MediaQuery.sizeOf(context).height* 0.1, 
   validationRegEx: NAME_VALIDATION_REGEX,
    onSaved: (value){
      setState(() {
        name=value;
      },
      );
    },
    ),
       CustomFormField(hintText: "Email", height:MediaQuery.sizeOf(context).height* 0.1, 
   validationRegEx: EMAIL_VALIDATION_REGEX,
    onSaved: (value){
      setState(() {
        email=value;
      },
      );
    },
    ),
     CustomFormField(hintText: "Password", height:MediaQuery.sizeOf(context).height* 0.1, 
   validationRegEx: PASSWORD_VALIDATION_REGEX,
    onSaved: (value){
      setState(() {
        password=value;
      },
      );
    },
    ),
    _registerButton(),
      ],
    ),
    ),
    );
  }
  Widget _pfpSelectionFiled()//image selection using image picker
  {
    return GestureDetector(
      onTap: () async {
        File? file=await _mediaService.getImageFromGallery();
        if(file!=null)
        {
          setState(() {
            selectedImage=file;
          });
        }
      },
      child: CircleAvatar(
        radius:MediaQuery.of(context).size.width*0.06,
        backgroundImage:selectedImage!=null?FileImage(selectedImage!): NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }
  Widget _registerButton()
  {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading=true;
          });
          try{
              if((_registerFormKey.currentState?.validate()?? false) && selectedImage!=null)
              {
                _registerFormKey.currentState?.save();
                bool result = await _authService.signup(email!, password!);
                if(result)
                {
                  String? pfpURL=await _stortageServices.uploadUserPfp(
                    file: selectedImage!, 
                    uid: _authService.user!.uid,
                    );
                    if(pfpURL!=null)
                    {
                      await _databaseservice.createUserProfile(userProfile: UserProfile(
                        uid:_authService.user!.uid,
                        name:name,
                        pfpURL:pfpURL, ),

                        );
                        _navigationService.goBack();
                        _navigationService.pushReplacementNamed("/home");
                    }
                    else{
                      print("failed to upload profile");
                  throw Exception("Unable to upload user profile picture");
                }
                                  
                }
                else{
                  throw Exception("Unable to register user");
                }
                  
                
              }
          }
          catch(e)
          {
            print(e);
          }
          setState(() {
            isLoading=false;
          });
        },
        child: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,

          )
        ),
      ),
    );
  }
   Widget _loginAccountLink()
  {
    return  Expanded(
      child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
       children: [
       const Text("Already Have an account?"),
        GestureDetector(
          onTap: (){
            _navigationService.goBack();
          },
          child: const Text(
            "Log in", 
            style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
          ),
        ),
       ],
    ),
    );
  }
}
