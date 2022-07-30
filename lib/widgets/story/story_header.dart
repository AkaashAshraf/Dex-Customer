import 'package:flutter/material.dart';

class StoryHeader extends StatelessWidget {
  final String imageLink;
  StoryHeader({this.imageLink});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: new BoxDecoration(
            border: Border.all(color: Theme.of(context).secondaryHeaderColor),
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill, image: new NetworkImage(imageLink))));
  }
}
