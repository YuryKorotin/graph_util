class ExpressionNode {
  var _value;

  ExpressionNode _left;
  ExpressionNode _right;

  @override
  String toString() {
    return _value;
  }

  ExpressionNode(this._value) {
    _left = null;
    _right = null;
  }

  String get value => _value;

  ExpressionNode get left => _left;

  ExpressionNode get right => _right;

  set left(ExpressionNode value) {
    _left = value;
  }

  set right(ExpressionNode value) {
    _right = value;
  }


  set value(value) {
    _value = value;
  }
}