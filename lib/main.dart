import 'package:dues/providers/user_provider.dart';
import 'package:dues/screens/expense_adder_screen.dart';
import 'package:dues/screens/login_screen.dart';
import 'package:dues/widget/drawer.dart';
import 'package:dues/widget/expense_list.dart';
import 'package:dues/widget/summery_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(DuesApp());
}

class DuesApp extends StatefulWidget {
  @override
  _DuesAppState createState() => _DuesAppState();
}

class _DuesAppState extends State<DuesApp> {
  bool signedIn;

  @override
  void initState() {
    
    FirebaseAuth.instance.currentUser().then((value) {
      if (value != null)
        setState(() {
          signedIn = true;
        });
      else
        setState(() {
          signedIn = false;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => UserProvider(),
      child: MaterialApp(
        title: 'Dues',
        home: signedIn == null
            ? Scaffold(
                body: Center(
                  child: Text('Loading...'),
                ),
              )
            : !signedIn ? LoginScreen() : MyHomePage(),
        theme: ThemeData(
            primaryColor: Colors.teal[400], accentColor: Colors.orange[900]),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).getUserData();
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Dues"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Summery(),
          ExpenseList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        heroTag: ExpenseAdder(),
        backgroundColor: Colors.orange[900],
        child: Icon(
          Icons.add,
          size: 26,
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ExpenseAdder()));
        },
      ),
    );
  }
}
