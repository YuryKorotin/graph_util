import 'dart:async';

import 'package:graph_util/src/models/expression_result.dart';
import 'package:graph_util/src/net/models/wolfram_result.dart';
import 'package:graph_util/src/processors/expression_evaluator.dart';
import 'package:graph_util/src/repositories/wolframalpha_repository.dart';
import 'package:graph_util/src/widgets/graph_widget.dart';
import 'package:graph_util/src/states/drawing_state.dart';
import 'package:graph_util/src/states/error_state.dart';
import 'package:graph_util/src/states/graph_state.dart';
import 'package:graph_util/src/states/initial_state.dart';
import 'package:graph_util/src/states/progress_state.dart';
import 'package:graph_util/src/states/showing_image_state.dart';

class GraphBloc {
  WolframalphaRepository _wolframalphaRepository;
  ExpressionEvaluator _evaluator;
  GraphState _currentState;

  final _graphController = StreamController<GraphState>.broadcast();
  Stream<GraphState> get graphStream => _graphController.stream;

  GraphBloc() {
    this._wolframalphaRepository = WolframalphaRepository();
    this._currentState = InitialState(GraphState.CUSTOM_MODE);
    this._evaluator = ExpressionEvaluator();
  }

  GraphState getCurrentState() {
    return _currentState;
  }

  _cloneStateFields(GraphState prevState) {
    _currentState.setEndValue(prevState.getEndValue());
    _currentState.setStartValue(prevState.getStartValue());
    _currentState.setExpression(prevState.getExpression());
  }

  processExpression() {
    var prevState = _currentState;
    _currentState = ProgressState(_currentState.getMode());
    _cloneStateFields(prevState);

    _graphController.add(_currentState);

    if (_currentState.getMode() == GraphState.WOLFRAM_MODE) {
      _requestWolfram(_currentState.getExpression());
    } else if (_currentState.getMode() == GraphState.CUSTOM_MODE) {
      _requestEvaluation(_currentState.getExpression());
    }
  }

  _requestWolfram(String query) {
    var formattedQuery = "$query x from ${_currentState.getStartValue()} to ${_currentState.getEndValue()}";

    _wolframalphaRepository
        .getExpressionResult(formattedQuery)
        .listen((dynamic result) {
      if (result is WolframResult) {
        var prevState = _currentState;
        _currentState = ShowingImageState(prevState.getMode(), result);
        _cloneStateFields(prevState);
      } else {
        var prevState = _currentState;
        _currentState = ErrorState(_currentState.getMode(), "Error while wolfram request");
        _cloneStateFields(prevState);
      }
      _graphController.add(_currentState);
    });
  }

  _requestEvaluation(query) {
    _evaluator
        .processQuery(query, _currentState.getStartValue(), _currentState.getEndValue())
        .then((result) => _processEvaluationResult(result));
  }

  _processEvaluationResult(ExpressionResult result) {
    if (result.coordinates.isNotEmpty) {
      var prevState = _currentState;
      _currentState =
          DrawingState(_currentState.getMode(), result.coordinates);
      _cloneStateFields(prevState);
    } else {
      var prevState = _currentState;
      _currentState =
          ErrorState(
              _currentState.getMode(),
              "Error was caught during evaluation of expression");
      _cloneStateFields(prevState);
    }
    _graphController.add(_currentState);
  }

  updateState(Map changes) {
    _currentState.setMode(changes[GraphWidget.MODE_KEY]);
    _currentState.setStartValue(changes[GraphWidget.START_VALUE_KEY]);
    _currentState.setEndValue(changes[GraphWidget.END_VALUE_KEY]);
    _currentState.setExpression(changes[GraphWidget.EXPRESSION_KEY]);

    _graphController.add(_currentState);
  }
}