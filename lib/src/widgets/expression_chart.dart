import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:graph_util/src/models/chart_entry.dart';

import 'chart_painter.dart';

class ExpressionChart extends StatelessWidget {
  final List<ChartEntry> entries;

  ExpressionChart(this.entries);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: Size(400, 250),
      painter: new ChartPainter(this.entries),
    );
  }
}