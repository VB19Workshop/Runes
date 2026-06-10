import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runes/state/note_data.dart';
import 'package:runes/screens/runes_app.dart';

//Not using google_fonts package here to avoid SDK incompatibilities

// APP ENTRY UI

void main() {
  // This will initialize the app on load

  runApp(
    // This will add the root widget to rendering
    MultiProvider(
      // A widget that registers multiple dependency providers at once
      providers: [ChangeNotifierProvider(create: (_) => NoteData())],
      child: const MyApp(), // This is the object being wrapped by the providers
    ),
  );
}

// Dev Notes:
// MultiProvider = root widget that registers app-wide systems/data
// MyApp = app shell (structure layer)
// MaterialApp = configures and renders the visible app (navigation, theme, etc.)
// RunesApp = the actual screen/UI the user interacts with

// This is the app structure
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Constant means the widget can be reused over getting fully rebuilt.
  // Key helps identify the widget during rebuilds

  @override // Tells the engine we're going to replace the parent class method with our own
  Widget build(BuildContext context) {
    // This builds and returns the UI to be rendered
    return const MaterialApp(home: RunesApp()); // Starts the app on this screen
  }
}

// Dev Notes:
// StatelessWidget describes UI and has no internal mutable state
// Immutable = the widget configuration cannot change after creation
