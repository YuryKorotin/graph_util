import 'dart:async';

import 'package:graph_util/src/models/expression_result.dart';
import 'package:graph_util/src/net/models/wolfram_result.dart';
import 'package:graph_util/src/processors/expression_evaluator.dart';
import 'package:graph_util/src/repositories/wolframalpha_repository.dart';
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

  processExpression(String query) {
    _currentState = ProgressState(_currentState.getMode());
    _graphController.add(_currentState);

    if (_currentState.getMode() == GraphState.WOLFRAM_MODE) {
      _requestWolfram(query);
    } else if (_currentState.getMode() == GraphState.CUSTOM_MODE) {
      _requestEvaluation(query);
    }
  }

  _requestWolfram(String query) {
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

  changeMode(mode) {
    _currentState.setMode(mode);
    _graphController.add(_currentState);
  }
}