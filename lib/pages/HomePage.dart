import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Task 1'),
          subtitle: Text(
              'Description of Task 1\nDue Date: 2023-10-01\nStatus: Incomplete'),
        ),
        ListTile(
          title: Text('Task 2'),
          subtitle: Text(
              'Description of Task 2\nDue Date: 2023-10-02\nStatus: Completed'),
        ),
      ],
    );
  }
}
