class GraphState {
  static const int CUSTOM_MODE = 1;
  static const int WOLFRAM_MODE = 2;

  static const String CUSTOM_MODE_LABEL = "CUSTOM";
  static const String WOLFRAM_MODE_LABEL = "WOLFRAM";

  int _mode = CUSTOM_MODE;

  GraphState(this._mode);

  int getMode() {
    return _mode;
  }

  setMode(int mode) {
    _mode = mode;
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