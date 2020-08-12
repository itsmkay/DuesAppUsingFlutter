import 'package:dues/screens/expense_screen.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String name;
  final String transactioID;
  final double total;
  TransactionItem(this.name, this.data, this.transactioID, this.total);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return ExpenseScreen(transactioID, data, total);
            }));
          },
          child: Card(
            elevation: 3,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: data['subracted from total'] > 0
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                        height: 44,
                        width: 44,
                        child: Center(
                          child: Text(
                            '₹',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(data['description'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            data['subracted from total'] > 0
                                ? Text(
                                    '$name paid ₹ ' + data['amount'].toString(),
                                    style: TextStyle(color: Colors.grey))
                                : Text(
                                    'you paid ₹ ' + data['amount'].toString(),
                                    style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      data['subracted from total'] > 0
                          ? Text(
                              'you borrowed',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            )
                          : Text(
                              'you lent',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                      data['subracted from total'] > 0
                          ? Text(
                              '₹ ' + data['subracted from total'].toString(),
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18),
                            )
                          : Text(
                              '₹ ' + data['added to total'].toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
