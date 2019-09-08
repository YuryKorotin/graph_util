import 'package:graph_util/src/models/expression_result.dart';
import 'package:graph_util/src/net/models/wolfram_result.dart';
import 'package:graph_util/src/net/wolfram_api_client.dart';

class WolframalphaRepository {
  final _apiClient = WolframAPIClient ();
  Stream<WolframResult> getExpressionResult(String query) {

    return _apiClient.requestResultForQuery(query).asStream();
  }
}