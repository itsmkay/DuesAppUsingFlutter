import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dues/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatelessWidget {
  final Map<String, dynamic> transactonData;
  final String transactionID;
  final double total;
  ExpenseScreen(this.transactionID, this.transactonData, this.total);
  @override
  Widget build(BuildContext context) {
    String photoUrl = Provider.of<UserProvider>(context).photo;
    String name = Provider.of<UserProvider>(context).name;
    String uid = Provider.of<UserProvider>(context).userID;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(transactonData['description']),
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
                margin: EdgeInsets.only(top: 38),
                child: Row(
                  children: <Widget>[
                    Container(
                      color: Colors.blue[100],
                      height: 54,
                      width: 54,
                      child: Center(
                        child: Text(
                          '₹',
                          style: TextStyle(color: Colors.black, fontSize: 32),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '₹ ' + transactonData['amount'].toString(),
                            style: TextStyle(
                                fontSize: 38,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text('Added on ' + transactonData['date'],
                              style: TextStyle(
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'SPLIT DETAILS',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: transactonData['paidBy']
                                  .toString()
                                  .contains('YOU')
                              ? NetworkImage(photoUrl)
                              : null,
                          child: transactonData['paidBy']
                                  .toString()
                                  .contains('YOU')
                              ? null
                              : Text(
                                  transactonData['paidBy'].toString()[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          transactonData['paidBy'].toString().contains('YOU')
                              ? name
                              : transactonData['paidBy'].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'paid',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '₹ ' + transactonData['amount'].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: transactonData['paidBy']
                                  .toString()
                                  .contains('YOU')
                              ? null
                              : NetworkImage(photoUrl),
                          child: transactonData['paidBy']
                                  .toString()
                                  .contains('YOU')
                              ? Text(
                                  transactonData['with'].toString()[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          transactonData['paidBy'].toString().contains('YOU')
                              ? transactonData['with'].toString()
                              : name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          'owes',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '₹ ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        Text(
                          transactonData['subracted from total'] > 0
                              ? transactonData['subracted from total']
                                  .toString()
                              : transactonData['added to total'].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(top: 24),
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          onPressed: () {
                            Firestore.instance
                                .collection(uid)
                                .document(transactonData['with'].toString())
                                .collection('transactions')
                                .document(transactionID)
                                .delete();

                            

                            Firestore.instance
                                .collection(uid)
                                .document(transactonData['with'].toString()).setData(
                                  {'total': total - transactonData['added to total'] + transactonData['subracted from total']}
                                );

                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'DELETE EXPENSE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          color: Colors.redAccent[700],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
