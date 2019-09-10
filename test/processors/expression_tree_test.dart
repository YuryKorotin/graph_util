import 'package:flutter_test/flutter_test.dart';
import 'package:graph_util/src/processors/expression_tree.dart';

void main() {
  test('Test expression tree isOperator', () {
    var tree = ExpressionTree("x + 5");

    expect(true, tree.isOperator("+"));
    expect(true, tree.isOperator("-"));
    expect(true, tree.isOperator("*"));
    expect(true, tree.isOperator("/"));
    expect(false, tree.isOperator("s"));
  });

  test('Test isParameter', () {
    var tree = ExpressionTree("x + 5");

    expect(true, tree.isParameter("x"));
  });

  test('Test isNumber', () {
    var tree = ExpressionTree("x + 5");

    expect(true, tree.isNumber("23"));
  });

  test('Test expression tree parseExpression', () {
    var tree = ExpressionTree("(x + 4)");

    tree.startEvaluation();

    expect("+", tree.getRoot().value);
  });
}