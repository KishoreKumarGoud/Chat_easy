// ignore_for_file: unused_import, unused_field

import 'package:chat_easy/services/auth_service.dart';
import 'package:chat_easy/services/navigation_services.dart';
import 'package:chat_easy/widgets/consts.dart';
import 'package:chat_easy/widgets/custom_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GetIt _getIt=GetIt.instance;
  final GlobalKey<FormState> _loginFormkey = GlobalKey();
  late AuthService _authService;
  late NavigationService _navigationService;
  String? email,password;
  @override
 void initState()
 {
  super.initState();
  _authService=_getIt.get<AuthService>();
  _navigationService=_getIt.get<NavigationService>();
 }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }
  Widget _buildUI()
  {
    return  SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
             _headerText(), 
             _loginForm(),
             _createAnAccountLink(),
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
            "Welcome,you have been missed!!",
            style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800),
          ),
        ],
      
      ),
    );
  }
 Widget _loginForm()
  {
    return Container(
      height: MediaQuery.sizeOf(context).height*0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height*0.05,
      ),

      child: Form(
         key: _loginFormkey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ignore: prefer_const_constructors
            CustomFormField(
              height: MediaQuery.sizeOf(context).height*0.1,
              hintText: "Email", 
              validationRegEx: EMAIL_VALIDATION_REGEX,
              onSaved: (value){
                setState(() {
                  email=value;
                });
              }
            ),
             CustomFormField(
              height: MediaQuery.sizeOf(context).height*0.1,
             hintText: "Password", validationRegEx: PASSWORD_VALIDATION_REGEX,
             obscureText: false,
              onSaved: (value){
                setState(() {
                  password=value;
                });
              }
            ),
            _loginButton(),
          ],
        )
      )
    );
  }
  Widget _loginButton()
  {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if(_loginFormkey.currentState?.validate()?? false)
          {
            _loginFormkey.currentState?.save();
            bool result =await _authService.login(email!,password!);
            if(result)
            {
              _navigationService.pushReplacementNamed("/home");
            }
            else{}
          }
        },
      color:Theme.of(context).colorScheme.primary,
      child:const Text(
       "login" ,
       style: TextStyle(
        color: Colors.white,
       ),
       )
      ),
    );
  }
  Widget _createAnAccountLink()
  {
    return  Expanded(
      child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
       children: [
       const Text("Don't have an account?"),
        GestureDetector(
          onTap: (){
            _navigationService.pushNamed("/register");
          },
          child: const Text(
            "sign up", 
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