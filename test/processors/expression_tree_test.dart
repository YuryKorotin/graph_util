import 'package:flutter_test/flutter_test.dart';
import 'package:graph_util/src/processors/expression_tree.dart';

void main() {
  const String TEST_EXPRESSION = "x + 5";

  test('Test expression tree isOperator', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    expect(true, tree.isOperator("+"));
    expect(true, tree.isOperator("-"));
    expect(true, tree.isOperator("*"));
    expect(true, tree.isOperator("/"));
    expect(false, tree.isOperator("s"));
  });

  test('Test isParameter', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    expect(true, tree.isParameter("x"));
  });

  test('Test isNumber', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    expect(true, tree.isNumber("23"));
  });

  test('Test expression tree parseExpression', () {
    var tree = ExpressionTree("5 + 6");

    tree.startEvaluation();

    expect("+", tree.getRoot().value);
  });

  test('Test expression tree evaluation for values', () {
    var tree = ExpressionTree("5 + x");

    var result = tree.evaluateForValues("x", 2, 10);

    expect(7, result[0]);
  });


  test('Test expression tree evaluation for parabola', () {
    var tree = ExpressionTree("5 * x * x + 4 * x");

    var result = tree.evaluateForValues("x", 2, 10);

    expect(28, result[0]);
  });

  test('Test applying plus operator', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    var result = tree.applyOperator("+", 4, 5);
    var expectedResult = 9;

    expect(expectedResult, result);
  });

  test('Test applying minus operator', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    var result = tree.applyOperator("-", 6, 5);
    var expectedResult = 1;

    expect(expectedResult, result);
  });

  test('Test applying multiplication operator', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    var result = tree.applyOperator("*", 6, 5);
    var expectedResult = 30;

    expect(expectedResult, result);
  });

  test('Test applying divide operator', () {
    var tree = ExpressionTree(TEST_EXPRESSION);

    var result = tree.applyOperator("/", 10, 5);
    var expectedResult = 2;

    expect(expectedResult, result);
  });
}