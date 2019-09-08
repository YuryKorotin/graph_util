import 'package:flutter/cupertino.dart';

import 'graph_bloc.dart';

class GraphBlocProvider extends InheritedWidget {
  final GraphBloc bloc;
  final Widget child;

  GraphBlocProvider({this.bloc, this.child}) : super(child: child);
  static GraphBlocProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(GraphBlocProvider);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}