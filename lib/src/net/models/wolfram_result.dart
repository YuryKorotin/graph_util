class WolframResult {
  List<double> coordinates;

  WolframResult.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json['list'];
  }
}