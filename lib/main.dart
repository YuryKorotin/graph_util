import 'package:flutter/material.dart';
import 'package:graph_util/src/blocs/graph_bloc.dart';
import 'package:graph_util/src/blocs/graph_bloc_provider.dart';
import 'package:graph_util/src/screens/graph_screen.dart';

void main() => runApp(GraphApp());

class GraphApp extends StatelessWidget {
  final bloc = GraphBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphBlocProvider(
        bloc: bloc,
        child: GraphScreen(
          title: 'Diagram of your expressions',
        ),
      )
    );
  }
}