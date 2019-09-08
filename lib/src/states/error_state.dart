import 'package:graph_util/src/states/graph_state.dart';

class ErrorState extends GraphState {
  String _message;
  ErrorState(int mode, this._message) : super(mode);
}