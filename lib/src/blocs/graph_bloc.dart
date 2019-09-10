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

  processExpression() {
    _currentState = ProgressState(_currentState.getMode());
    _graphController.add(_currentState);

    if (_currentState.getMode() == GraphState.WOLFRAM_MODE) {
      _requestWolfram(_currentState.getExpression());
    } else if (_currentState.getMode() == GraphState.CUSTOM_MODE) {
      _requestEvaluation(_currentState.getExpression());
    }
  }

  _requestWolfram(String query) {
    var formattedQuery = "$query from x = ${_currentState.getStartValue()} to ${_currentState.getEndValue()}";

    _wolframalphaRepository
        .getExpressionResult(query)
        .listen((dynamic result) {
      if (result is WolframResult) {
        _currentState = ShowingImageState(_currentState.getMode(), result);
      } else {
        _currentState = ErrorState(_currentState.getMode(), "Error while wolfram request");
      }
      _graphController.add(_currentState);
    });
  }

  _requestEvaluation(query) {
    _evaluator
        .processQuery(query)
        .then((result) => _processEvaluationResult(result));
  }

  _processEvaluationResult(ExpressionResult result) {
    if (result.coordinates.isNotEmpty) {
      _currentState = DrawingState(_currentState.getMode(), result.coordinates);
    } else {
      _currentState = ErrorState(_currentState.getMode(), "Error was caught during evaluation of expression");
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