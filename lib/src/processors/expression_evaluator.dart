import 'package:graph_util/src/models/chart_entry.dart';
import 'package:graph_util/src/models/expression_result.dart';

import 'expression_tree.dart';

class ExpressionEvaluator {
  Future<ExpressionResult> processQuery(
      String query, 
      int paramStartValue, 
      int paramEndValue) async {
    var tree = ExpressionTree(query);

    var result = tree
        .evaluateForValues("x", paramStartValue, paramEndValue)
        .map((value) => value.toDouble()).toList();

    var chartEntries = List<ChartEntry>();
    var j = 0;
    for(int i = paramStartValue; i < paramEndValue; i++) {
      chartEntries.add(ChartEntry(i, result[j]));
      j++;
    }
    
    return ExpressionResult(chartEntries);
  }
}