class Stack<T> {
  List<T> _data = new List();

  isEmpty() => _data.isEmpty;

  T peek() => _data[_data.length - 1];

  int size() => _data.length;

  void push(T item) => _data.insert(0, item);

  T pop() {

    var value = _data[0];

    _data.removeAt(0);

    return value;
  }
}