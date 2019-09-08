import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graph_util/src/blocs/graph_bloc.dart';
import 'package:graph_util/src/blocs/graph_bloc_provider.dart';
import 'package:graph_util/src/screens/graph_widget.dart';
import 'package:graph_util/src/states/graph_state.dart';
import 'package:graph_util/src/states/progress_state.dart';
import 'package:graph_util/src/states/showing_image_state.dart';

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
    Widget centerWidget = Container();
    if (snapshot.data is ProgressState) {
      centerWidget = Center(
        child: CircularProgressIndicator(),
      );
    }

    if (snapshot.data is ShowingImageState) {
      centerWidget = Center(
        child: Image.network(
            (snapshot.data as ShowingImageState).getData().getImageSource()
        ),
      );
    }

    var topWidget =  GraphWidget(
            (query) => {GraphBlocProvider.of(context).bloc.processExpression()},
            (changes) => {_updateState(context, changes)},
            GraphBlocProvider.of(context).bloc.getCurrentState()
    );

    return Container(
      child:
        Column(
            children: <Widget>[
              topWidget,
              centerWidget
          ]
        )
    );
  }

  _updateState(BuildContext context, Map changes) {
    GraphBloc bloc = GraphBlocProvider.of(context).bloc;

    bloc.updateState(changes);
  }
}