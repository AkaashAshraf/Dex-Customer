import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> dx;
  final Animation<double> dy;
  final Animation<Alignment> alignment;

  StaggerAnimation({Key key, this.controller}):

        opacity =  Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate( CurvedAnimation(parent: controller, curve:  Interval(0.0, 0.200, curve: Curves.ease))),

        dx =  Tween<double>(
            end: 20.0,
            begin: 60.0
        ).animate( CurvedAnimation(parent: controller, curve:  Interval(0.0, 1.0, curve: Curves.ease))),

        dy =  Tween<double>(
            end: 20.0,
            begin: 60.0
        ).animate( CurvedAnimation(parent: controller, curve:  Interval(0.0, 1.0, curve: Curves.ease))),

        alignment =  AlignmentTween(
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ).animate( CurvedAnimation(parent: controller, curve:  Interval(0.0, 1.0, curve: Curves.ease))),

        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child){
    return  Container(
        alignment: alignment.value,
        margin: EdgeInsets.only(top: 12.0, right: 5.0),
        child:  Opacity(
          opacity: opacity.value,
          child:  Container(
            width: dx.value,
            height: dy.value,
            decoration:  BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
