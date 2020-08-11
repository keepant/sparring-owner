import 'package:flutter/material.dart';
import 'package:sparring_owner/utils/utils.dart';

class DetailNotif extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  DetailNotif({
    Key key,
    this.title,
    this.content,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              content,
              style: TextStyle(
                fontSize: 19.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  Text(
                    formatDate(date),
                    style: TextStyle(fontSize: 13.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
