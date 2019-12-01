


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParabolaAnimation extends StatefulWidget{

  Offset startOffset;
  Offset endOffset;

  ParabolaAnimation(this.startOffset,this.endOffset);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ParabolaAnimationState();
  }

}

class ParabolaAnimationState extends State<ParabolaAnimation> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;
  double _fraction = 0.0;
  int _seconds = 3;
  Path _path;

  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this,duration: Duration(seconds: _seconds));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    WidgetsBinding.instance.addPostFrameCallback((_){
      startAnimation();
    });
    return CustomPaint(
      painter: PathPainter(_path, _fraction),
    );
  }

  startAnimation(){
    _path  = getPath();
    PathMetrics pms = _path.computeMetrics();
    int plen = pms.length;
    //only one path
    PathMetric pm = pms.elementAt(0);
    double pathLen = pm.length;

    _animation = Tween(begin: 0.0,end: pathLen).animate(_controller)
          ..addListener((){
            setState(() {
              _fraction = _animation.value;
              print("fraction  _____ $_fraction");
            });
          })
          ..addStatusListener((status){
            if(status == AnimationStatus.completed){
              _controller.stop();
            }
          });
  _controller.forward();

  }

  Path getPath(){
    print("start offset ${widget.startOffset.toString()}");
    print("end offset ${widget.endOffset.toString()}");
    Path path = Path();
    path.moveTo(widget.startOffset.dx, widget.startOffset.dy);
    path.quadraticBezierTo((widget.startOffset.dx + widget.endOffset.dx) / 2,
        widget.startOffset.dy,
        widget.endOffset.dx, widget.endOffset.dy);
    return path;
  }


}


class PathPainter extends CustomPainter{

  double fraction;
  Path _path;
  List<Offset> _points = List();

  PathPainter(this._path,this.fraction);

  Paint circleP = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if(_path == null) return;
    print("fraction  paint _____ $fraction");
    PathMetrics pms = _path.computeMetrics();
    PathMetric pm = pms.elementAt(0);
    double pathLen = pm.length;
    double circleR = 10;

    Offset circleCenterOffset;
    Tangent t = pm.getTangentForOffset(fraction);// 圆心
    circleCenterOffset = t.position;
    print("circle center ${circleCenterOffset.dx} + ${circleCenterOffset.dy}");
    canvas.drawCircle(circleCenterOffset, circleR, circleP);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}


















