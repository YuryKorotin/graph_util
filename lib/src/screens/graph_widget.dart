import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_util/src/states/graph_state.dart';

class GraphWidget extends StatelessWidget {
  final Function _evaluationCallback;
  final Function _changeModeCallback;
  final String _currentMode;

  GraphWidget(
      this._evaluationCallback,
      this._changeModeCallback,
      this._currentMode);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8.0),
            child: TextField(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8.0),
            child: TextField(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 8.0),
            child:  RaisedButton(
              onPressed: _evaluationCallback(""),
              child: const Text(
                  'Evaluate',
                  style: TextStyle(fontSize: 20)
              ),
            )
          ),
          new DropdownButton(
            value: _currentMode,
            items: getDropDownMenuItems(),
            onChanged: changedDropDownItem,
          )
        ],
      ),
    );
  }
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    items.add(new DropdownMenuItem(
        value: GraphState.CUSTOM_MODE_LABEL,
        child: new Text(GraphState.CUSTOM_MODE_LABEL)
    ));

    items.add(new DropdownMenuItem(
        value: GraphState.WOLFRAM_MODE_LABEL,
        child: new Text(GraphState.WOLFRAM_MODE_LABEL)
    ));

    return items;
  }

  void changedDropDownItem(String selectedModeLabel) {
    _changeModeCallback(GraphState.getIntModeFromLabel(selectedModeLabel));
  }
}