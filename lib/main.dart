import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './store/quiz_book.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  MyApp({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
  AppLocalizations myLocale = AppLocalizations.of(context);
    var title2 = 'Flutter Demo Home Page ' + myLocale.toString();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('mr'),
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.deepOrange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal, // Colors.lightBlue[400],
        accentColor: Colors.tealAccent,
      ),
      home: MyHomePage(title: title2),
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).helloWorld,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _finalResult = '';
  var correctIcon = Icon(Icons.check_circle, color: Colors.green,);
  var incorrectIcon = Icon(Icons.remove_circle_outline, color: Colors.red,);
  List<Icon> scoreKeeper = [];
  var _quizBook = QuizBook();
  var _appTitle='', _true='', _false='', _restart;

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero,() {
      var appLocalizations = AppLocalizations.of(context);
      _quizBook.initQuestions(appLocalizations);
      _appTitle = appLocalizations.appTitle;
      _restart = appLocalizations.restart;
      _true = appLocalizations.true_;
      _false = appLocalizations.false_;
    });
  }

  void checkAnswer(bool userPickedAnswer){
    bool correctAnswer = _quizBook.getCorrectAnswer();
    print("_quizBook.getCurrentIndex() : " + _quizBook.getCurrentIndex().toString());
    print("!_quizBook.isCompleted() : " + (!_quizBook.isCompleted()).toString());

    if(!_quizBook.isCompleted()){
      var isCorrect = userPickedAnswer == correctAnswer;
      scoreKeeper.add(isCorrect ? correctIcon : incorrectIcon);
      setState(() {
        if ( isCorrect) {_counter++;}
        _quizBook.nextQuestion();
        if(_quizBook.isCompleted()){
          _finalResult = AppLocalizations.of(context).scoreResult(
              _counter.toString() + "/" +
                  (_quizBook.getCurrentIndex() + 1).toString()).toString()
              + " - "+ (
              _counter == _quizBook.getTotalQuestions()
                  ? AppLocalizations.of(context).won
                  : _counter > _quizBook.getTotalQuestions() /2 ? AppLocalizations.of(context).valid : AppLocalizations.of(context).lost
          );
        }
      });
    }
  }
  void _resetCounter() {
    print("restart onPressed");
    setState(() {
      _quizBook.reset();
      scoreKeeper = [];
      _counter = 0;
      _finalResult = '';
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        title: Text(_appTitle),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_appTitle),
            Text('$_counter', style: Theme.of(context).textTheme.headline4),
            Text(_quizBook.getTotalQuestions() >0 ? _quizBook.getQuestionText() :''),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child:
                  TextButton.icon(
                      onPressed: !_quizBook.isCompleted() ? () {
                        print("true_ onPressed");
                        checkAnswer(true);
                      }:(){},
                      icon: Icon(Icons.check, color: Colors.green),
                      label: Text(_true)
                  ),
                ),
                Expanded(
                  child:
                  TextButton.icon(
                      onPressed: !_quizBook.isCompleted() ? () {
                        print("false_ onPressed");
                        checkAnswer(false);
                      }:(){},
                      icon: Icon(Icons.close, color: Colors.red,),
                      label: Text(_false)
                  ),
                ),
              ],
            ),
            Expanded(
              child:Text(_finalResult) ,
            ),
            Expanded(
              child:Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: scoreKeeper,
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetCounter,
        tooltip: _restart,
        child: Icon(Icons.reset_tv),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
