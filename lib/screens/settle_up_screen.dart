import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dues/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettleUpScreen extends StatefulWidget {
  final String name;
  final double total;

  SettleUpScreen(this.name, this.total);

  @override
  _SettleUpScreenState createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  TextEditingController amountController = TextEditingController();


  addDataToCloud(String uid) async {
    double money;

    try {
      await Firestore.instance
          .collection(uid)
          .document(widget.name)
          .get()
          .then((value) {
        if (value.exists)
          Firestore.instance.collection(uid).document(widget.name).get().then((value) {
            Firestore.instance
              .collection(uid)
              .document(widget.name)
              .setData({
            'total': value.data['total'] - widget.total,
          });
      
          });
          
        else
           Firestore.instance
              .collection(uid)
              .document(widget.name)
              .setData({
            'total': money,
          });
      });
    } catch (e) {}

    Firestore.instance
        .collection(uid)
        .document(widget.name)
        .collection('transactions')
        .add({
      'with': widget.name,
      'description': 'settlement amount',
      'date': DateFormat.MMMEd().format(DateTime.now()),
      'amount': double.parse(amountController.text),
      'paidBy': widget.total>0 ? '${widget.name}' : 'YOU',
      'split': false,
      'added to total':
          widget.total<0 ? 0-widget.total : 0,
      'subracted from total':
          widget.total>0 ? widget.total : 0,
      
    });
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {

    String uid = Provider.of<UserProvider>(context).userID;
    String photoUrl = Provider.of<UserProvider>(context).photo;

    amountController.text = widget.total > 0
        ? widget.total.toString()
        : (0 - widget.total).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settle up'),
        actions: <Widget>[
          FlatButton(child: Text('SAVE',style: TextStyle(color: Colors.white, fontSize: 16),),onPressed: () {addDataToCloud(uid);},),
          
        ],
      ),
      body: Container(
        height: 200,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(photoUrl),
                  
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(widget.total > 0 ? Icons.arrow_back : Icons.arrow_forward),
                ),
                CircleAvatar(
                  radius: 32,
                  child: Text(
                    widget.name[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,

                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            Text(widget.total > 0
                ? '${widget.name} paid you'
                : 'you paid ${widget.name}',
                style: TextStyle(color: Colors.black, fontSize: 18,),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 84.0),
              child: Row(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 11, horizontal: 18),
                      child: Text('₹',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        controller: amountController,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
