import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graph_util/src/blocs/graph_bloc.dart';
import 'package:graph_util/src/blocs/graph_bloc_provider.dart';
import 'package:graph_util/src/screens/graph_widget.dart';
import 'package:graph_util/src/states/graph_state.dart';
import 'package:graph_util/src/states/progress_state.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {

  @override
  Widget build(BuildContext context) {
    GraphBloc bloc = GraphBlocProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<GraphState>(
          initialData: bloc.getCurrentState(),
          stream: bloc.graphStream,
          builder: _buildBody
      ),
    );
  }

  Widget _buildBody(BuildContext context,
      AsyncSnapshot<GraphState> snapshot) {
    if (snapshot is ProgressState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GraphWidget((query) => {GraphBlocProvider.of(context).bloc.processExpression(query)},
        (mode) => {GraphBlocProvider.of(context).bloc.changeMode(mode)},
        GraphState.getLabelFromIntMode(GraphBlocProvider.of(context).bloc.getCurrentState().getMode())
    );
  }
}