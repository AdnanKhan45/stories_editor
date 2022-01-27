import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:stories_editor/src/constants/painting_type.dart';
import 'package:stories_editor/src/models/painting_model.dart';


class Sketcher extends CustomPainter {
  final List<PaintingModel> lines;

  Sketcher({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    var outlinePoints;

    for (int i = 0; i < lines.length; ++i) {
      switch(lines[i].paintingType){
        case PaintingType.PEN:
        // TODO: Handle this case.
          paint = Paint()
            ..color =  lines[i].lineColor;

          outlinePoints = getStroke(
            /// coordinates
            lines[i].points,
            /// line width
            size: lines[i].size,
            /// line thin
            thinning: 1,
            /// line smooth
            smoothing: 1,
            /// on complete line
            isComplete: lines[i].isComplete,
            streamline: 1,
            taperEnd: 0,
            taperStart: 0,
            capEnd: true,
            simulatePressure: true,
            capStart: true

          );
          break;
        case PaintingType.MARKER:
        // TODO: Handle this case.
          paint = Paint()
            ..strokeWidth = 5
            ..color =  lines[i].lineColor.withOpacity(0.7)
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5)
            ..strokeCap = StrokeCap.square
            ..filterQuality = FilterQuality.high
            ..style = PaintingStyle.fill;
          outlinePoints = getStroke(
            /// coordinates
            lines[i].points,
            /// line width
            size: lines[i].size,
            /// line thin
            thinning: 1,
            /// line smooth
            smoothing: 1,
            /// on complete line
            isComplete: lines[i].isComplete,

          );
          break;
        case PaintingType.BRUSH:
        // TODO: Handle this case.
          paint = Paint()
            ..strokeWidth = 5
            ..color =  lines[i].lineColor
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5)
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..strokeMiterLimit = 5
            ..filterQuality = FilterQuality.high
            ..style = PaintingStyle.stroke;

          outlinePoints = getStroke(
            /// coordinates
              lines[i].points,
              /// line width
              size: lines[i].size,
              /// line thin
              thinning: -0.1,
              /// line smooth
              smoothing: 1,
              /// on complete line
              isComplete: lines[i].isComplete,
              streamline:  lines[i].streamline,
              simulatePressure: lines[i].simulatePressure
          );
          break;
        case PaintingType.NEON:
        // TODO: Handle this case.
          paint = Paint()
            ..strokeWidth = 5
            ..color = lines[i].lineColor
            ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5)
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..strokeMiterLimit = 5
            ..filterQuality = FilterQuality.high
            ..style = PaintingStyle.stroke;

          outlinePoints = getStroke(
            /// coordinates
            lines[i].points,
            /// line width
            size: lines[i].size,
            /// line thin
            thinning: -0.1,
            /// line smooth
            smoothing: 1,
            /// on complete line
            isComplete: lines[i].isComplete,
            streamline:  lines[i].streamline,
            simulatePressure: lines[i].simulatePressure,
            taperStart: 0,
            taperEnd: 0,
            capStart: true,
            capEnd: true
          );
          break;
        case PaintingType.ERASE:
          // TODO: Handle this case.
        /// select brush marker (does not work :c)
          // paint.blendMode = BlendMode.clear;
          // paint.color = Colors.transparent;
          // paint.style = PaintingStyle.stroke;
          // paint.strokeWidth = 0;
          // paint.strokeCap = StrokeCap.round;
          // paint.isAntiAlias = true;
          // outlinePoints = getStroke(
          //   /// coordinates
          //   lines[i].points,
          //   /// line width
          //   size: lines[i].size,
          //   /// line thin
          //   thinning: -0.1,
          //   /// line smooth
          //   smoothing: 1,
          //   /// on complete line
          //   isComplete: lines[i].isComplete,
          // );
          break;
      }

      final path = Path();

      if (outlinePoints.isEmpty) {
        return;
      } else if (outlinePoints.length < 2) {
        // If the path only has one line, draw a dot.
        path.addOval(Rect.fromCircle(
            center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 1));
      } else {
        // Otherwise, draw a line that connects each point with a curve.
        path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

        for (int i = 1; i < outlinePoints.length - 1; ++i) {
          final p0 = outlinePoints[i];
          final p1 = outlinePoints[i + 1];
          path.quadraticBezierTo(
              p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
        }
      }

      canvas.drawPath(path, paint);
    }

  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return true;
  }
}
