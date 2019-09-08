import 'dart:convert';
import 'dart:io';

import 'package:graph_util/src/net/models/wolfram_result.dart';

class WeatherAPIClient {
  final _appId = '67JRL8-6HPY64EK22';
  final _baseUrl = 'https://api.wolframalpha.com/v2';

  final HttpClient _httpClient = HttpClient();

  Future<WolframResult> requestResultForQuery(input) async {
    final calculationRoute =
        '/query?input=$input&format=image,plaintext&output=JSON&appid=$_appId';
    final url = _baseUrl + calculationRoute;
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      String rawResponse = await response.transform(utf8.decoder).join();
      Map<String, dynamic> json = JsonCodec().decode(rawResponse);
      return WolframResult.fromJson(json);
    } else {
      throw Exception();
    }
  }
}