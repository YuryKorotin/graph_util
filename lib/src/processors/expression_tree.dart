import 'package:graph_util/src/processors/expression_node.dart';

class ExpressionTree {
  List<String> _expression;
  List<String> _expressionToEvaluate;
  ExpressionNode _root;

  ExpressionTree(String expression) {
    this._expression = expression.split(" ");
  }

  bool isOperator(String symbol) {
    var symbolOperatorString = "+-*/";

    return symbolOperatorString.contains(symbol);
  }

  bool isParameter(String symbol) {
    var parameters = ["x"];

    return parameters.contains(symbol);
  }

  bool isNumber(String symbol) {
    if(symbol == null) {
      return false;
    }
    return
        // ignore: deprecated_member_use
        int.parse(symbol, onError: (e) => null) != null;
  }

  ExpressionNode getRoot() {
    return _root;
  }

  void startEvaluation() {
    _expressionToEvaluate = List.of(_expression);
    _root = evaluate();
  }
  
  ExpressionNode evaluate() {
    String symbol = _expressionToEvaluate[0];
    _expressionToEvaluate.removeAt(0);
    ExpressionNode node = new ExpressionNode(symbol);

    if (isNumber(symbol) || isParameter(symbol)) {
      node.left = null;
      node.right = null;
    } else if (symbol == '(') {
      node.left = evaluate();
      node.value = _expressionToEvaluate[0];
      _expressionToEvaluate.removeAt(0);
      node.right = evaluate();
      symbol = _expressionToEvaluate[0];
      _expressionToEvaluate.removeAt(0);
      if (symbol != ')') {
        print("PARSING ERROR");
      }
    } else {
      print("PARSING ERROR");
      return null;
    }

    return node;
  }
}