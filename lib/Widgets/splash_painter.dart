
import 'package:flutter/material.dart';

import '../utils/color_resources.dart';

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = ColorResources.COLOR_BLUE
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    var path = Path();

    path.moveTo(0, size.height*0.040);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.10, size.width * 0.50, size.height * 0.05);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.001, size.width * 0.88, size.height * 0.01);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.011, size.width * 1, size.height * 0.03);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width * 1, size.height * 1.02, size.width * 0.85, size.height * 1.04);
    path.quadraticBezierTo(size.width * 0.65, size.height * 1.073, size.width * 0.45, size.height * 1.04);
    path.quadraticBezierTo(size.width * 0.25, size.height * 1, size.width * 0, size.height * 0.88);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
