import 'package:flutter/cupertino.dart';
import 'package:graph_util/src/models/chart_entry.dart';

class ChartPainter extends CustomPainter {
  final List<ChartEntry> entries;

  ChartPainter(this.entries);

  double leftOffsetStart;
  double topOffsetEnd;
  double drawingWidth;
  double drawingHeight;

  static const int NUMBER_OF_HORIZONTAL_LINES = 5;

  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(ChartPainter old) => true;

}