import 'package:flutter_test/flutter_test.dart';
import 'package:graph_util/src/processors/expression_tree.dart';

void main() {
  test('Test expression tree isOperator', () {
    var tree = ExpressionTree("x + e");

    expect(true, tree.isOperator("+"));
    expect(true, tree.isOperator("-"));
    expect(true, tree.isOperator("*"));
    expect(true, tree.isOperator("/"));
    expect(false, tree.isOperator("s"));
  });
}