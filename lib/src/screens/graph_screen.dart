import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graph_util/src/blocs/graph_bloc.dart';
import 'package:graph_util/src/blocs/graph_bloc_provider.dart';
import 'package:graph_util/src/states/drawing_state.dart';
import 'package:graph_util/src/widgets/expression_chart.dart';
import 'package:graph_util/src/widgets/graph_widget.dart';
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

  Widget topWidget;
  GraphBloc graphBloc;

  @override
  Widget build(BuildContext context) {
    graphBloc = GraphBlocProvider.of(context).bloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<GraphState>(
          initialData: graphBloc.getCurrentState(),
          stream: graphBloc.graphStream,
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

    if (snapshot.data is DrawingState) {
      centerWidget = Center(
        child: ExpressionChart(
            (snapshot.data as DrawingState).data
        ),
      );
    }

    topWidget =  GraphWidget(
            () => {graphBloc.processExpression()},
            (changes) => {_updateState(context, changes)},
        graphBloc.getCurrentState()
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
    graphBloc.updateState(changes);
  }
}