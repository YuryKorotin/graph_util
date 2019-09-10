import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graph_util/src/states/graph_state.dart';

class GraphWidget extends StatelessWidget {
  static const String MODE_KEY = "mode";
  static const String START_VALUE_KEY = "start_value";
  static const String END_VALUE_KEY = "end_value";
  static const String EXPRESSION_KEY = "expression";

  final Function _evaluationCallback;
  final Function _changeStateCallback;
  final GraphState _state;
  var changes = Map();

  GraphWidget(
      this._evaluationCallback,
      this._changeStateCallback,
      this._state){
    changes[START_VALUE_KEY] = _state.getStartValue();
    changes[END_VALUE_KEY] = _state.getEndValue();
    changes[EXPRESSION_KEY] = _state.getExpression();
    changes[MODE_KEY] = _state.getMode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 32.0, right: 32),
            child: TextField(
                onChanged: (value) => {_onExpressionChanged(value)},
                controller: TextEditingController(text: _state.getExpression())
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 28.0, right: 32),
            child:
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child:
                        Text('From', style: TextStyle(fontSize: 20))),

                    Container(width: 50.0,
                        padding: EdgeInsets.only(left: 8.0),
                        child:
                        TextField(
                            onChanged: (value) => {_onStartValueChanged(value)},
                            controller: TextEditingController(text: _state.getStartValue().toString()))
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 8.0),
                        child:
                        Text('To', style: TextStyle(fontSize: 20))
                    ),
                    Container(width: 50.0,
                        padding: EdgeInsets.only(left: 8.0) ,
                        child:
                        TextField(
                            onChanged: (value) => {_onEndValueChanged(value)},
                            controller: TextEditingController(text: _state.getEndValue().toString()))
                    )
                  ]
                )
          ),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 28.0),
                  child: DropdownButton(
                    value: GraphState.getLabelFromIntMode(_state.getMode()),
                    items: getDropDownMenuItems(),
                    onChanged: changedDropDownItem,
              )),
              Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 32.0),
                  child:  RaisedButton(
                    onPressed: _startEvaluation,
                    child: const Text(
                        'Evaluate',
                        style: TextStyle(fontSize: 20)
                    ),
                  )
              )
            ]
          )
        ],
      ),
    );
  }

  _onStartValueChanged(String value) {
    changes[START_VALUE_KEY] = int.parse(value);
  }

  _onEndValueChanged(String value) {
    changes[END_VALUE_KEY] = int.parse(value);
  }

  _onExpressionChanged(String value) {
    changes[EXPRESSION_KEY] = value;
  }

  _startEvaluation() {
    print(changes);
    _changeStateCallback(changes);
    _evaluationCallback();
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
    changes[MODE_KEY] = GraphState.getIntModeFromLabel(selectedModeLabel);
    _changeStateCallback(changes);
  }
}