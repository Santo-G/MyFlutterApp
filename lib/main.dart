import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ----  MAIN  ---- //
void main() {
  runApp(MyApp()); // tells Flutter to run the app defined in MyApp
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
  var current = WordPair.random(); // current random word pair

  void getNext() {
    current = WordPair.random();
    notifyListeners(); // a method of ChangeNotifier that ensures that anyone watching MyAppState is notified
  }

  var favorites = <WordPair>[];   // empty list

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  // Every widget defines a build() method that's automatically called
  // every time the widget's circumstances change so that the widget is always up to date.
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); // MyHomePage tracks changes to the app's current state using the watch method
    var pair = appState.current; // actual data needed by new text widget !!!

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      // Every build method must return a widget or (more typically) a nested tree of widgets
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10),   // takes space and doesn't render anything by itself. It's commonly used to create visual "gaps"
            Row(
              mainAxisSize: MainAxisSize.min,   // tells Row not to take all available horizontal space
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite();
                    },
                    icon: Icon(icon),
                    label: Text('Like')
                ),
                SizedBox(width: 18),
                ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text('Next')
                ),
              ],
            )
          ],
        ),
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
    final theme = Theme.of(context);
    // Random color generation
    // var generatedColor = Random().nextInt(Colors.primaries.length);
    // Colors.primaries[generatedColor];

    // Text style setting
    // theme.textTheme --> access the app's font theme
    // members such as bodyMedium (for standard text of medium size), caption (for captions of images), or headlineLarge (for large headlines)
    // displayMedium property is a large style meant for display text.
    // The word display is used in the typographic sense here, such as in display typeface.
    // The documentation for displayMedium says that "display styles are reserved for short, important text"
    // copyWith() called on displayMedium returns a copy of the text style with the changes you define (changing the text's color)
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // parent widget
      elevation: 15.0,
      color: theme.colorScheme.primary,
      child: Padding(
        // Composition over Inheritance (padding is not an attribute in this case)
        padding: const EdgeInsets.all(20.0),
        // child: Text(pair.asLowerCase, style: TextStyle(color: Colors.primaries[Random().nextInt(Colors.primaries.length)],),),
        child: Text(
          "${pair.first} ${pair.second}",
          style: style,
        ),
      ),
    );
  }
}
