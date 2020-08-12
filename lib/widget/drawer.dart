import 'package:dues/providers/user_provider.dart';
import 'package:dues/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    String photoUrl = Provider.of<UserProvider>(context).photo;
    String name = Provider.of<UserProvider>(context).name;
    String email = Provider.of<UserProvider>(context).email;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return LoginScreen();
                }));
              });
            },
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
