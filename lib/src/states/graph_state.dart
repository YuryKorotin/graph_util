class GraphState {
  static const int CUSTOM_MODE = 1;
  static const int WOLFRAM_MODE = 2;

  static const String CUSTOM_MODE_LABEL = "CUSTOM";
  static const String WOLFRAM_MODE_LABEL = "WOLFRAM";

  static const String START_EXPRESSION = "x * x + 4 * x + 3";

  int _mode = CUSTOM_MODE;
  String _expression = START_EXPRESSION;
  int _startValue = 2;
  int _endValue = 10;

  GraphState(this._mode);

  int getMode() {
    return _mode;
  }

  setMode(int mode) {
    _mode = mode;
  }

  setStartValue(int startValue) {
    _startValue = startValue;
  }

  int getStartValue() {
    return _startValue;
  }

  setEndValue(int endValue) {
    _endValue = endValue;
  }

  int getEndValue() {
    return _endValue;
  }

  setExpression(String expression) {
    _expression = expression;
  }

  String getExpression() {
    return _expression;
  }

  static String getLabelFromIntMode(int mode) {
    if (CUSTOM_MODE == mode) {
      return CUSTOM_MODE_LABEL;
    } else if (WOLFRAM_MODE == mode) {
      return WOLFRAM_MODE_LABEL;
    }
  }

  static int getIntModeFromLabel(String modeLabel) {
    if (CUSTOM_MODE_LABEL == modeLabel) {
      return CUSTOM_MODE;
    } else if (WOLFRAM_MODE_LABEL == modeLabel) {
      return WOLFRAM_MODE;
    }
  }
}