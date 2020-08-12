import 'package:dues/models/account_summer_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Accounts with ChangeNotifier {
  List<AccountSummery> _accounts = [
    AccountSummery('Rahul', 5375),
    AccountSummery('Kuldeep', 250),
    AccountSummery('Chetna', 2000),
    AccountSummery('Manoj', 1000),
    AccountSummery('Anupam', 329),
  ];

  List<AccountSummery> get accounts {
    return [..._accounts];
  }

  Future<void> fetchAndSetAccounts() async{
    final docs = Firestore.instance.collection('Dues').snapshots();
    docs.forEach((element) { 
      List<DocumentSnapshot> docs = element.documents.toList();
      for(int i=0;i<docs.length;i++){
        AccountSummery newAccount = AccountSummery(docs[i].documentID, docs[i].data['total']);
        _accounts.add(newAccount);
        
      }
    });
  }

}
