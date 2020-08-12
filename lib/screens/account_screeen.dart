import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dues/providers/user_provider.dart';
import 'package:dues/screens/settle_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expense_adder_screen.dart';
import '../widget/transaction_item.dart';

class Account extends StatefulWidget {
  final String docID;
  

  Account(this.docID);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  double total = 0;
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context).userID;
    Stream<DocumentSnapshot> docRef = Firestore.instance.collection(uid).document(widget.docID).snapshots();
    docRef.listen((event) { 
      setState(() {
        total = event.data['total'];
      });
    });

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 10,
            title: Text(widget.docID),
            expandedHeight: 240,
            centerTitle: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: new EdgeInsets.only(top: 66),
                height: MediaQuery.of(context).padding.top + 66,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 32,
                        child: Text(
                          widget.docID[0],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      total > 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${widget.docID} owes you ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '₹ ' + total.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : total < 0
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'you owe ${widget.docID} ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    Text(
                                      '₹ ' + (0 - total).toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'you and ${widget.docID} are all settled up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                      FlatButton(
                        disabledColor: Colors.grey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: Text(
                            'SETTLE UP',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: total != 0 ? () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                            return SettleUpScreen(widget.docID, total); 
                          }));
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        
          StreamBuilder(
              stream: Firestore.instance
                  .collection('$uid/${widget.docID}/transactions')
                  .snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                return SliverList(
                  
                  delegate: SliverChildListDelegate(
                    snapshot.hasData
                        ? snapshot.data.documents.map((e) {
                            return TransactionItem(widget.docID, e.data, e.documentID, total);
                          }).toList()
                        : [Center(child: Text('Loading...'))],
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: Icon(
          Icons.add,
          size: 26,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExpenseAdder(name: widget.docID)));
        },
      ),
    );
  }
}
