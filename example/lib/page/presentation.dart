import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/scopes/extensions.dart';
import 'package:applithium_core_example/page/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyScreen extends StatefulWidget {
  MyScreen({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  MyBloc? bloc;

  Presenters get _presenters => Presenters(
    dialogPresenter: (path) => showDialog(context: context, builder: (context) => Text("Dialog")),
    toastPresenter: (path) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sending Message")))
  );

  @override
  Widget build(BuildContext context) {
    bloc = MyBloc(context.get(), _presenters);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("MyScreen"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => bloc?.add(MyEvents.incrementClicked()),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<MyBloc, BaseState>(
            bloc: bloc,
            builder: (BuildContext context, BaseState state) {
              if (state is ContentState && state.value != null) {
                return buildBody(state.value!);
              } else {
                return Center(
                    child: Text("error ${state.error ?? "undefined"}"));
              }
            })
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget buildBody(int counter) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
