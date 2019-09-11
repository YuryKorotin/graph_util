import 'package:graph_util/src/processors/expression_node.dart';

import 'stack.dart';

class ExpressionTree {
  List<String> _expression;
  List<String> _expressionToEvaluate;
  Stack<String> _operators;
  Stack<dynamic> _output;

  ExpressionNode _root;
  var parameterValues = {"x": 2};

  ExpressionTree(String expression) {
    this._expression = expression.split(" ");
  }

  void setParameter(String parameter, int value) {
    parameterValues[parameter] = value;
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

  int applyOperator(
      String operator,
      int firstOperand,
      int secondOperand) {

    if (operator == "+") {
      return firstOperand + secondOperand;
    } else if (operator == "-") {
      return firstOperand - secondOperand;
    } else if (operator == "*") {
      return firstOperand * secondOperand;
    } else if (operator == "/") {
      return (firstOperand / secondOperand).toInt();
    }

    return firstOperand + secondOperand;
  }

  ExpressionNode getRoot() {
    return _root;
  }

  void startEvaluation() {
    _expressionToEvaluate = List.of(_expression);
    _output = Stack();
    _operators = Stack();

    _root = null;

    parse();
  }

  List<int> evaluateForValues(String parameter, int startOfRange, int endOfRange) {
    List<int> result = List();

    startEvaluation();
    for(int i = startOfRange; i <= endOfRange; i++) {
      setParameter(parameter, i);
      result.add(evaluate(_root));
    }

    return result;
  }

  int evaluate(ExpressionNode node) {
    var token = node.value;
    if (isOperator(token)) {
      return applyOperator(token, evaluate(node.left), evaluate(node.right));
    } else if (isNumber(token)) {
      return int.parse(token);
    } else if (isParameter(token)) {
      return parameterValues[token];
    } else {
      return int.parse(token);
    }
  }

  ExpressionNode parse() {
    if (_expressionToEvaluate.length == 0)
      return null;
    if (_expressionToEvaluate.length == 1) {
      return ExpressionNode(_expressionToEvaluate[0]);
    }

    var i = 0;
    while(i < _expressionToEvaluate.length) {
      var token;
      if (!isNumber(token) && !isParameter(token)) {
        token = _expressionToEvaluate[i];
        i++;
      } else {
        var j = i + 1;
        while(j < _expressionToEvaluate.length &&
            !isNumber(_expressionToEvaluate[j]) &&
            !isParameter(_expressionToEvaluate[j])) {
          j++;
        }
        token = _expressionToEvaluate[j];
        i = j;
      }

      if (token == '(') {
        _operators.push(token);
      } else if (token == ')') {
        while(_operators.peek() != '(') {
          var subtree = createSubtree(_operators.pop(), null);
          _output.push(subtree);
        }
        _operators.pop();
      } else if (token.length == 1 && !isNumber(token) && !isParameter(token)) { // token length can be taken out
        var operator = token;
        if (!_operators.isEmpty() && lessOrEqualInPrecedenceTo(operator, _operators.peek())) {
          var subtree = createSubtree(_operators.pop(), null);
          _output.push(subtree);
        }
        _operators.push(operator);
      } else {
        _output.push(token);
      }
    }

    while (!_operators.isEmpty()) {
      updateTree();
    }

    if (_root == null && _output.size() == 1 && _output.peek() is ExpressionNode) {
      _root = _output.pop();
    }
  }

  void updateTree() {
    var operator = _operators.pop();
    var outputItem = _output.pop();

    if (_root == null) {
      _root = new ExpressionNode(operator);
      var left = _output.pop();
      _root.left = left is ExpressionNode? left : ExpressionNode(left);
      _root.right = outputItem is ExpressionNode ? outputItem: new ExpressionNode(outputItem);
    } else {
      var subtree = _root;
      _root = new ExpressionNode(operator);
      _root.left = outputItem is ExpressionNode ? outputItem : new ExpressionNode(outputItem);
      _root.right = subtree;
    }
  }

  ExpressionNode createSubtree(var operator, ExpressionNode tree) {
    if (tree == null) {
      var right = _output.pop();
      var left = _output.pop();
      tree = ExpressionNode(operator);
      tree.right = right is ExpressionNode ? right : ExpressionNode(right);
      tree.left = left is ExpressionNode? left : ExpressionNode(left);
    } else {
      var subtree = tree;
      var left = _output.pop();
      tree = ExpressionNode(operator);
      tree.right = subtree;
      tree.left = left is ExpressionNode ? left : ExpressionNode(left);
    }

    if (!_operators.isEmpty() &&
        lessOrEqualInPrecedenceTo(operator, _operators.peek())) {
      return createSubtree(_operators.pop(), tree);
    } else {
      return tree;
    }
  }

  lessOrEqualInPrecedenceTo(firstOperator, secondOperator) {
    if (firstOperator == "+" || firstOperator == "-") {
      return true;
    }

    if ((firstOperator == "*" || firstOperator == "/") &&
        (secondOperator == "+" || secondOperator == "-")) {
      return false;
    }

    return true;
  }
}