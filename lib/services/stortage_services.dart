// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as p;


class StortageServices
{
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  
  StorageSerivce()
  {}
    Future<String?> uploadUserPfp(
      {
        required File file,
        required String uid,

      })async {
        Reference fileRef=_firebaseStorage.
        ref('users/pfps').
        child('$uid${p.extension(file.path)}');
        UploadTask task=fileRef.putFile(file);
        return task.then((p)
        {
          if(p.state==TaskState.success)
          {
            return fileRef.getDownloadURL();
          }
        },
        );
      }
    
  }
  
