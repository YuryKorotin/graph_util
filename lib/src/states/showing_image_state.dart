import 'package:graph_util/src/net/models/wolfram_result.dart';

import 'graph_state.dart';

class ShowingImageState extends GraphState {
  final WolframResult _data;
  WolframResult getData() {
    return _data;
  }
  ShowingImageState(int mode, this._data) : super(mode);
}