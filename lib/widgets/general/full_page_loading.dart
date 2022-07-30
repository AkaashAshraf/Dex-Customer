import 'package:flutter/material.dart';

class FullLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Opacity(
                opacity: 0.5,
                child: Container(
                  color: Colors.white70,
                ))),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
