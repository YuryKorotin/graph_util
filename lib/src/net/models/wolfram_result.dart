class WolframResult {
  String _imageSource;

  String getImageSource() {
    return _imageSource;
  }

  WolframResult.fromJson(Map<String, dynamic> json) {
    List<dynamic> pods = json['queryresult']['pods'];

    this._imageSource = "";

    var subPods = pods[1]['subpods'];
    this._imageSource = subPods[0]['img']['src'];
  }
}