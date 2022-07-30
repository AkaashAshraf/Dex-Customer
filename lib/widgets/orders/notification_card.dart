import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final bool isSeen;
  NotificationCard({this.title, this.isSeen});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSeen
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
      ),
      child: Center(
        child: Expanded(
          child: Text(
            title.toString(),
            textAlign: Localizations.localeOf(context).languageCode == 'ar'
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
