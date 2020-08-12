import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dues/providers/user_provider.dart';
import 'package:dues/screens/account_screeen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context);
    return user.userID != null
        ? Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection(user.userID).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong'),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('You are all settled up'),
                  );
                }
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: getExpenseItems(snapshot),
                );
              },
            ),
          )
        : Center(
            child: Text('Loading...'),
          );
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map(
          (doc) => Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                elevation: 3,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return Account(doc.documentID);
                        },
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text(
                      doc.documentID[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  title: Text(doc.documentID),
                  trailing: doc['total'] < 0
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'You owe',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 12),
                            ),
                            Text(
                              '₹ ' + (0 - doc['total']).toString(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18),
                            )
                          ],
                        )
                      : doc['total'] > 0
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Owes you',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12),
                                ),
                                Text(
                                  '₹ ' + doc["total"].toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18),
                                )
                              ],
                            )
                          : Text(
                              'settled up',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
