import 'package:flutter/cupertino.dart';
import 'package:graph_util/src/models/chart_entry.dart';

import 'chart_painter.dart';

class ProgressChart extends StatelessWidget {
  static const int NUMBER_OF_POINTS = 31;
  final List<ChartEntry> entries;

  ProgressChart(this.entries);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new ChartPainter(this.entries),
    );
  }
}