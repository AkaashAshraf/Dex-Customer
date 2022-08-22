import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Load(var _height) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      SizedBox(
        width: _height - 20,
        height: _height - 20,
        child: FlareActor("assets/flrs/loadingCircles.flr",
            alignment: Alignment.center,
            fit: BoxFit.fill,
            color: Color(0xffed8437),
            animation: "Loading"),
      ),
      Text('loading').tr()
    ],
  );
}

ImageLoad(_height) {
  return SizedBox(
    width: _height - 20,
    height: _height - 20,
    child: FlareActor(
      "assets/flrs/loadingCircles.flr",
      alignment: Alignment.center,
      fit: BoxFit.fill,
      animation: "Loading",
      color: Color(0xffed8437),
    ),
  );
}

LilLoad(_height) {
  return SizedBox(
    width: _height - 20,
    height: _height - 20,
    child: FlareActor("assets/flrs/loadingCircles.flr",
        color: Colors.black,
        alignment: Alignment.center,
        fit: BoxFit.cover,
        animation: "Loading"),
  );
}
