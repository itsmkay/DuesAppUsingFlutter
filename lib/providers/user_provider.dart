import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _photoUrl;
  String _username;
  String _userEmail;
  String _uid;

  void getUserData() async {
    FirebaseUser user = await _auth.currentUser();
    _photoUrl = user.photoUrl;
    _username = user.displayName;
    _userEmail = user.email;
    _uid = user.uid;
    // print(_uid);
    notifyListeners();
  }

  String get photo {
    String photo = _photoUrl;
    //print(photo);
    return photo;
  }

  String get name {
    String name = _username;
    //print(name);
    return name;
  }

  String get email {
    String email = _userEmail;
    //print(email);
    return email;
  }

  String get userID {
    String userID = _uid;
    //print(userID);
    return userID;
  }

}
