import 'package:graph_util/src/models/chart_entry.dart';
import 'package:graph_util/src/states/graph_state.dart';

class DrawingState extends GraphState {
  final List<ChartEntry> _data;

  List<ChartEntry> get data => _data;

  DrawingState(int mode, this._data) : super(mode);
}