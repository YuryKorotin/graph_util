import 'dart:ui';
import 'dart:math' as math;
import 'dart:ui' as prefix0;


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_util/src/models/chart_entry.dart';
import 'package:tuple/tuple.dart';

class ChartPainter extends CustomPainter {
  final List<ChartEntry> _entries;

  static const int NUMBER_OF_HORIZONTAL_LINES = 10;
  int numberOfEntries = 0;

  ChartPainter(this._entries){
    numberOfEntries = _entries.length;
  }

  double leftOffsetStart;
  double topOffsetEnd;
  double drawingWidth;
  double drawingHeight;

  @override
  void paint(Canvas canvas, Size size) {
    leftOffsetStart = size.width * 0.05;
    topOffsetEnd = size.height * 0.8;
    drawingWidth = size.width * 0.80;
    drawingHeight = topOffsetEnd;

    if (_entries.isNotEmpty) {
      Tuple2<int, int> borderLineValues = _getMinAndMaxValues();
      _drawHorizontalLinesAndLabels(
          canvas, size, borderLineValues.item1, borderLineValues.item2);
      //_drawBottomLabels(canvas, size);

      _drawLines(canvas, borderLineValues.item1, borderLineValues.item2);
    }
  }

  void _drawLines(Canvas canvas, int minLineValue, int maxLineValue) {
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..strokeWidth = 3.0;
    for (int i = 0; i < _entries.length - 1; i++) {
      Offset startEntryOffset = _getEntryOffset(
          _entries[i], minLineValue, maxLineValue);
      Offset endEntryOffset = _getEntryOffset(
          _entries[i + 1], minLineValue, maxLineValue);
      canvas.drawLine(startEntryOffset, endEntryOffset, paint);
      canvas.drawCircle(endEntryOffset, 3.0, paint);
    }
    canvas.drawCircle(
        _getEntryOffset(
            _entries.first, minLineValue, maxLineValue),
        5.0,
        paint);
  }

  Tuple2<int, int> _getMinAndMaxValues() {
    double maxValue = _entries.map((entry) => entry.ordinate).reduce(math.max);
    double minValue = _entries.map((entry) => entry.ordinate).reduce(math.min);

    int maxLineValue = maxValue.ceil();
    int difference = maxLineValue - minValue.floor();
    int toSubtract = (NUMBER_OF_HORIZONTAL_LINES - 1) -
        (difference % (NUMBER_OF_HORIZONTAL_LINES - 1));
    if (toSubtract == NUMBER_OF_HORIZONTAL_LINES - 1) {
      toSubtract = 0;
    }
    int minLineValue = minValue.floor() - toSubtract;

    return new Tuple2(minLineValue, maxLineValue);
  }

  void _drawHorizontalLine(Canvas canvas, double yOffset, Size size,
      Paint paint) {
    canvas.drawLine(
      new Offset(leftOffsetStart, 5 + yOffset),
      new Offset(size.width, 5 + yOffset),
      paint,
    );
  }

  void _drawHorizontalLabel(int maxLineValue, int line, int lineStep,
      Canvas canvas, double yOffset) {
    Paragraph paragraph =
    _buildParagraphForLeftLabel(maxLineValue, line, lineStep);
    canvas.drawParagraph(
      paragraph,
      new Offset(0.0, yOffset),
    );
  }

  Paragraph _buildParagraphForLeftLabel(int maxLineValue, int line,
      int lineStep) {
    ParagraphBuilder builder = new ParagraphBuilder(
      new ParagraphStyle(
        fontSize: 10.0,
        textAlign: TextAlign.right,
      ),
    )
      ..pushStyle(new prefix0.TextStyle(color: Colors.black))
      ..addText((maxLineValue - line * lineStep).toString());
    final Paragraph paragraph = builder.build()
      ..layout(new ParagraphConstraints(width: leftOffsetStart - 4));
    return paragraph;
  }

  void _drawBottomLabels(Canvas canvas, Size size) {
    for (int daysFromStart = numberOfEntries;
    daysFromStart >= 0;
    daysFromStart -= 7) {
      double offsetXbyDay = drawingWidth / (numberOfEntries);
      double offsetX = leftOffsetStart + offsetXbyDay * daysFromStart;
      Paragraph paragraph = _buildParagraphForBottomLabel(daysFromStart);
      canvas.drawParagraph(
        paragraph,
        new Offset(offsetX - 50.0, 10.0 + drawingHeight),
      );
    }
  }

  Paragraph _buildParagraphForBottomLabel(int daysFromStart) {
    ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(fontSize: 10.0, textAlign: TextAlign.right))
      ..pushStyle(new prefix0.TextStyle(color: Colors.black))
      ..addText(_entries[daysFromStart].ordinate.toString());
    final Paragraph paragraph = builder.build()
      ..layout(ParagraphConstraints(width: 50.0));
    return paragraph;
  }


  double get _calculateHorizontalOffsetStep {
    return drawingHeight / (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  int _calculateHorizontalLineStep(int maxLineValue, int minLineValue) {
    return (maxLineValue - minLineValue) ~/ (NUMBER_OF_HORIZONTAL_LINES - 1);
  }

  void _drawHorizontalLinesAndLabels(Canvas canvas, Size size, int minLineValue,
      int maxLineValue) {
    final paint = new Paint()
      ..color = Colors.grey[300];
    int lineStep = _calculateHorizontalLineStep(maxLineValue, minLineValue);
    double offsetStep = _calculateHorizontalOffsetStep;
    for (int line = 0; line < NUMBER_OF_HORIZONTAL_LINES; line++) {
      double yOffset = line * offsetStep;
      _drawHorizontalLabel(maxLineValue, line, lineStep, canvas, yOffset);
      _drawHorizontalLine(canvas, yOffset, size, paint);
    }
  }

  Offset _getEntryOffset(ChartEntry entry,
      int minLineValue, int maxLineValue) {
    int daysFromBeginning = entry.abscissa;

    double relativeXposition = daysFromBeginning / numberOfEntries;
    double xOffset = leftOffsetStart + relativeXposition * drawingWidth;
    double relativeYposition =
        (entry.ordinate - minLineValue) / (maxLineValue - minLineValue);
    double yOffset = 5 + drawingHeight - relativeYposition * drawingHeight;
    return new Offset(xOffset, yOffset);
  }

  @override
  bool shouldRepaint(ChartPainter old) => true;
}