import 'package:graph_util/src/models/chart_entry.dart';

class ExpressionResult {
  final List<ChartEntry> _coordinates;

  List<ChartEntry> get coordinates => _coordinates;

  ExpressionResult(this._coordinates);
}