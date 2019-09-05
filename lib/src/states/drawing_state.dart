import 'package:graph_util/src/states/calculator_state.dart';

class DrawingState extends CalculatorState {
  final List<double> _data;
  DrawingState(int mode, this._data) : super(mode);
}