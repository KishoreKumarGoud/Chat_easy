// import 'dart:io';

// import 'package:image_picker/image_picker.dart';

// class MediaService 
// {
//   final ImagePicker _picker=ImagePicker();
//   MediaService(){}
  
// Future<File?> getImageFromGallery() async{
//   final XFile? _file =await _picker.pickImage(source: ImageSource.gallery);
//   if(_file!=null)
//   {
//     return File(_file.path);
//   }
//   return null;
// }
//   }

import 'dart:io' if (dart.library.html) 'dart:html'; // Conditional import
import 'package:flutter/foundation.dart';


import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();
  
  MediaService();

  Future<dynamic> getImageFromGallery() async {
    final XFile? _file = await _picker.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      if (kIsWeb) {
        // Return the XFile directly on web
        return _file;
      } else {
        // Return a File on mobile/desktop
        return File(_file.path);
      }
    }
    return null;
  }
}
