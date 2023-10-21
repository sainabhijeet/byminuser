import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue.withOpacity(0.1);
    var position = Offset(size.width /10, size.height / 25);
    canvas.drawCircle(position, 100.0, paint);
    var position1 = Offset(size.width /1.3, size.height / 25);
    canvas.drawCircle(position1, 50.0, paint);
    var position2 = Offset(size.width /1.08, size.height / 3);
    canvas.drawCircle(position2, 70.0, paint);
    var position3 = Offset(size.width /4, size.height / 2.8);
    canvas.drawCircle(position3, 25.0, paint);
    var position4 = Offset(size.width /1.4, size.height / 1.5);
    canvas.drawCircle(position4, 25.0, paint);
    var position5 = Offset(size.width /12, size.height / 1.5);
    canvas.drawCircle(position5, 70.0, paint);
    var position6 = Offset(size.width /2.5, size.height / 1.2);
    canvas.drawCircle(position6, 50.0, paint);
    var position7 = Offset(size.width /1.1, size.height / 1.03);
    canvas.drawCircle(position7, 100.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
