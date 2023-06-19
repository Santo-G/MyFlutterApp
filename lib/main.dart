import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';


Position? _position;

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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

  var favorites = <WordPair>[]; // empty list

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  // saving string value into shared preferences
  addStringToSF(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    notifyListeners();
  }

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    _position = position;
    notifyListeners();
  }

}

Future<String> getStringValuesSF(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString(key)!;
  return stringValue;
}

class MyHomePage extends StatefulWidget {
  // StatefulWidget contains a mutable state of his own (it can change itself)
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // this class can manage its own values (underscore (_) at the start of _MyHomePageState makes that class private)

  var selectedIndex = 0;

  // Every widget defines a build() method that's automatically called
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = AndroidPage();
        break;
      case 3:
        page = ApplePage();
        break;
      case 4:
        page = SettingsPage();
        break;
      case 5:
        page = CustomForm();
        break;
      case 6:
        page = ShPreferences();
        break;
      case 7:
        page = Map();
        break;
      case 8:
        page = Placeholder(
          color: Colors.white,
        ); // handy widget that draws a crossed rectangle wherever you place it, marking that part of the UI as unfinished
        break;
      default:
        throw UnimplementedError(
            'no widget for $selectedIndex'); // throw an error (fail-fast principle)
    }

    return LayoutBuilder(builder: (context, constraints) {
      // builder callback is called every time the constraints change (resize, rotate etc)
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              // ensures that its child is not obscured by a hardware notch or a status bar
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                // shows the labels next to the icons - responds to its environment changes
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.android),
                    label: Text('Android'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.apple),
                    label: Text('Apple'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.app_registration),
                    label: Text('Form'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.save),
                    label: Text('Preferences'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.map),
                    label: Text('Map'),
                  ),
                ],
                selectedIndex: selectedIndex,
                // default destination index selected at startup
                onDestinationSelected: (value) {
                  // defines what happens when the user selects one of the destinations (similar to notifyListeners()-  makes sure that the UI updates)
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              // useful in rows and columns—they let you express layouts where some children take only as much space as they need
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                // child: GeneratorPage(),
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
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

    // Every build method must return a widget or (more typically) a nested tree of widgets
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          // takes space and doesn't render anything by itself. It's commonly used to create visual "gaps"
          Row(
            mainAxisSize: MainAxisSize.min,
            // tells Row not to take all available horizontal space
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like')),
              SizedBox(width: 18),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next')),
            ],
          )
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context, ) {
    var appState = context.watch<MyAppState>();
    var pairList = appState.favorites;

    Text text;
    if (pairList.isEmpty) {
      text = Text('You have ${appState.favorites.length} favorites:');
    } else {
      text = Text('Warning! Favorite list is empty !!!');
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: text,
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class AndroidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/animations/android_animation.gif'),
    );
  }
}

class ApplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('assets/animations/apple_animation.gif'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: (() {
            AppSettings.openBluetoothSettings(callback: () {
              print("sample callback function called");
            });
          }),
          child: Text('Open Bluetooth Settings'),
        ),
        SizedBox(
          height: 28,
        ),
        ElevatedButton(
          onPressed: (() {
            AppSettings.openWIFISettings(callback: () {
              print("sample callback function called");
            });
          }),
          child: Text('Open Wi-Fi Settings'),
        ),
      ]),
    );
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CustomForm extends StatelessWidget {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShPreferences extends StatelessWidget {

  late String currentInput;

  @override
  Widget build(BuildContext context) {


    var counter = 0;
    var appState = context.watch<MyAppState>();
    // Create a text controller and use it to retrieve the current value
    // of the TextField.
    final myController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: myController,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                currentInput = myController.text;
                appState.addStringToSF('0', currentInput);
                currentInput = "";
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('String added!')),
                );
              },
              child: const Text('Save'),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var tmpInput = await getStringValuesSF('0');  // using "await" to wait for the result requested
                currentInput = myController.text;
                if (currentInput == tmpInput) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('String found in SharedPreferences data!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('String NOT found in SharedPreferences data!')),
                  );
                }
              },
              child: const Text('Check'),
            ),
          ],
        ),
      ],
    );
  }
}


Future<Position> _determinePosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
// When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
        appBar: AppBar(
          title: Text('Geolocation Example'),
        ),
        body: Center(
          child: _position != null ? Text('Current Location: \n' + _position.toString()): Text('No location data'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { appState.getCurrentLocation(); },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }
}
