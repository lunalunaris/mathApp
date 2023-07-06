import 'package:flutter/material.dart';
import '../Database/SqliteHandler.dart';
import 'Model/Practice.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( Home());
}
class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SqliteHandler handler;
  Future<void> _incrementCounter() async{
    await addPractice();
    setState(() {
      _counter++;
    });
  }
  Future<void> addPractice() async {
    Practice practice= Practice(id: 'id1',topicId: 'id2', img: 'someurl', result: '4',solutions: ['somesolution','someothersolution'], content: 'some task' );
    print(practice);
    return await handler.insertSavedPractice(practice);
  }
  @override
  void initState() {
    super.initState();
    handler = SqliteHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
