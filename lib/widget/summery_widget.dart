import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dues/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Summery extends StatefulWidget {
  @override
  _SummeryState createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  double total(AsyncSnapshot<QuerySnapshot> snapshot) {
    double sum = 0;
    if (snapshot.hasData) {
      snapshot.data.documents.forEach((element) {
        sum = sum + element['total'];
      });
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    String photoUrl = Provider.of<UserProvider>(context).photo;
    String uid = Provider.of<UserProvider>(context).userID;
    return uid != null
        ? StreamBuilder(
            stream: Firestore.instance.collection(uid).snapshots(),
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Card(
                elevation: 20,
                margin: EdgeInsets.zero,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: EdgeInsets.only(bottom: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              photoUrl != null ? NetworkImage(photoUrl) : null,
                          child: photoUrl == null
                              ? Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                )
                              : null,
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 40,
                        ),
                      ),
                      Text(
                        'TOTAL BALANCE',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.amber[400]),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      total(snapshot) < 0
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'you owe ',
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '₹ ' + (0 - total(snapshot)).toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                  mainAxisSize: MainAxisSize.min,
                                ),
                              ),
                            )
                          : Card(
                            
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'you are owed ',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '₹ ' + (total(snapshot)).toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ],
                                  mainAxisSize: MainAxisSize.min,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          )
        : Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Center(
              child: Text('Loading...'),
            ),
          );
  }
}
