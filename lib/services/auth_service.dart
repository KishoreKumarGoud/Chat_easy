
import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:core';
import 'dart:core';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';



class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  // ignore: non_constant_identifier_names
  User? get user{
    return _user;
  }

  AuthService()
  {
      _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }

  //get user => null;
  Future<bool> login(String email,String Password) async
  {
    try
    {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: Password);
      if (credential.user!=null)
      {
        _user=credential.user;
        return true;
      }
    }catch(e)
    {
      print(e);
    }
    return false;
  }
  // ignore: non_constant_identifier_names
  Future<bool> signup(String email, String password) async 
  {
    try{
      final credential=await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user!=null)
      {
        _user=credential.user;
        return true;
      }
    }
    catch(e)
    {
      print(e);
    }
    return false;
  }
  
  
  
  Future<bool> logout() async {
  try{
     await _firebaseAuth.signOut();
     return true;
  }
  catch(e)
  {
    print(e);
  }
 return false;
  }
  void authStateChangesStreamListener(User? user)
  {
    if(user!=null)
    {
      _user=user;
    }
    else{
      _user=null;
    }
  }
}

