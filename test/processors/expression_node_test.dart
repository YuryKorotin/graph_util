import 'package:flutter_test/flutter_test.dart';
import 'package:graph_util/src/processors/expression_node.dart';

void main() {
  test('Test expression node creation', () {
    var testValue = "x";

    ExpressionNode node = ExpressionNode(testValue);

    expect(testValue, node.toString());
  });
}