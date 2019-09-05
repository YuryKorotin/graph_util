class CalculatorState {
  static const int CUSTOM_MODE = 1;
  static const int WOLFRAM_MODE = 2;
  int _mode = CUSTOM_MODE;

  CalculatorState(this._mode);
}