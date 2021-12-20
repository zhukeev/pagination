import 'package:flutter/material.dart';
import 'package:pagination/ui/screen/pokemon_list_screen/pokemon_list_screen.dart';

/// App main widget.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData.dark(),
      home: const PokemonListScreen(),
    );
  }
}
