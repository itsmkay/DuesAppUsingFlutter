import 'package:dues/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseAdder extends StatefulWidget {
  final String name;

  ExpenseAdder({this.name});
  @override
  _ExpenseAdderState createState() => _ExpenseAdderState();
}

class _ExpenseAdderState extends State<ExpenseAdder> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String paidBy = 'YOU';
  bool split = false;

  addDataToCloud(String uid) async {
    double money;
    if (paidBy.contains('YOU')) {
      money = split
          ? double.parse(amountController.text) / 2
          : double.parse(amountController.text);
    } else {
      money = split
          ? 0 - double.parse(amountController.text) / 2
          : 0 - double.parse(amountController.text);
    }

    try {
      await Firestore.instance
          .collection(uid)
          .document(nameController.text)
          .get()
          .then((value) {
        if (value.exists)
          Firestore.instance
              .collection(uid)
              .document(nameController.text)
              .get()
              .then((value) {
            Firestore.instance
                .collection(uid)
                .document(nameController.text)
                .setData({
              'total': value.data['total'] + money,
            });
          });
        else
          Firestore.instance
              .collection(uid)
              .document(nameController.text)
              .setData({
            'total': money,
          });
      });
    } catch (e) {}

    Firestore.instance
        .collection(uid)
        .document(nameController.text)
        .collection('transactions')
        .add({
      'description': descController.text,
      'with': nameController.text,
      'date': DateFormat.MMMEd().format(DateTime.now()),
      'amount': double.parse(amountController.text),
      'paidBy': paidBy,
      'split': split,
      'added to total': paidBy.contains('YOU')
          ? (split
              ? double.parse(amountController.text) / 2
              : double.parse(amountController.text))
          : 0,
      'subracted from total': paidBy.contains('YOU')
          ? 0
          : (split
              ? double.parse(amountController.text) / 2
              : double.parse(amountController.text)),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context).userID;
    if (widget.name != null) {
      nameController.text = widget.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () {
              addDataToCloud(uid);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          color: Color.fromARGB(255, 249, 251, 247),
          //color: Colors.amber,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TextFormField(
                enabled: widget.name == null ? true : false,
                maxLines: 1,
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                decoration: InputDecoration(
                    icon: Text('With you and:'),
                    hintText: 'Enter name',
                    fillColor: Colors.grey[300],
                    border: InputBorder.none),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Icon(Icons.description),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextField(
                          controller: descController,
                          maxLines: 1,
                          decoration:
                              InputDecoration(hintText: 'Enter a description'),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
              SizedBox(
                height: 14,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Paid by'),
                  GestureDetector(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(paidBy),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                    title: Text('You'),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      paidBy = 'YOU';
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                if (nameController.text.isNotEmpty)
                                  GestureDetector(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                      title: Text(nameController.text),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        paidBy = nameController.text;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Split equally',
                    style: TextStyle(color: Colors.black),
                  ),
                  Switch(
                    value: split,
                    onChanged: (value) {
                      setState(() {
                        split = !split;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
