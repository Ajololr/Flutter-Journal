import 'package:flutter/material.dart';
import 'package:flutter_group_journal/widgets/loginSreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Journal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginsScreen(),
    );
  }
}