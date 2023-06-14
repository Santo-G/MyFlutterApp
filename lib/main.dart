import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ----  MAIN  ---- //
void main() {
  runApp(MyApp());  // tells Flutter to run the app defined in MyApp
}


// ----  MyApp WIDGET  ---- //
// Widgets are the elements from which you build every Flutter app.
// Even the app itself is a widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // The state is created and provided to the whole app using a ChangeNotifierProvider.
    // This allows any widget in the app to get hold of the state.
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(), // home widget - starting point of the app !!!
      ),
    );
  }

}

// ----  MyAppState STATE CLASS  ---- //
// Class that defines the app's state.
// It defines the data the app needs to function.
// The state class extends ChangeNotifier, which means that it can notify others about its own changes.
// For example, if the current word pair changes, some widgets in the app need to know.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();  // current random word pair
  void getNext() {
    current = WordPair.random();
    notifyListeners();  // a method of ChangeNotifier that ensures that anyone watching MyAppState is notified
  }
}


class MyHomePage extends StatelessWidget {

  // Every widget defines a build() method that's automatically called
  // every time the widget's circumstances change so that the widget is always up to date.
  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>(); // MyHomePage tracks changes to the app's current state using the watch method
    var pair = appState.current;  // actual data needed by new text widget !!!

    return Scaffold(  // Every build method must return a widget or (more typically) a nested tree of widgets
      body: Column(
        children: [
          Text('\nThis is the new home page. \nPress the button to generate a random word!\n'),
          BigCard(pair: pair),
          ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'))
        ],
      ),
    );
  }
}


// Having separate widgets for separate logical parts of your UI is an important way
// of managing complexity in Flutter
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Card(  // parent widget
      child: Padding( // Composition over Inheritance (padding is not an attribute in this case)
        padding: const EdgeInsets.all(16.0),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}


















