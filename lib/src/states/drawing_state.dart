import 'package:graph_util/src/states/graph_state.dart';

class DrawingState extends GraphState {
  final List<double> _data;
  DrawingState(int mode, this._data) : super(mode);
}