class ExpressionTree {
  String _expression;

  ExpressionTree(this._expression);

  bool isOperator(String symbol) {
    var symbolOperatorString = "+-*/";

    return symbolOperatorString.contains(symbol);
  }
}