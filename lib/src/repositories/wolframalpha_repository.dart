import 'package:graph_util/src/models/expression_result.dart';

class WolframalphaRepository {
   Future<ExpressionResult> getExpressionResult() async {

     await Future.delayed(Duration(seconds: 2));

     return ExpressionResult([1.2, 1.3]);
   }
}