class ChartEntry {
  int _abscissa;
  double _ordinate;

  ChartEntry(this._abscissa, this._ordinate);

  toJson() {
    return {
      "abscissa": _abscissa,
      "ordinate": _ordinate
    };
  }

  double get ordinate => _ordinate;

  int get abscissa => _abscissa;
}