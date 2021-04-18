import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/models/user.modal.dart';
import 'package:flutter_group_journal/widgets/loginSreen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => LocaleModel(context)),
    ],
    child: App(),
  ));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: Provider.of<LocaleModel>(context).getString("screen_login"),
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Consumer<UserModel>(
              builder: (context, user, child) {
                return user.isLoggedIn ? Text("Logged in") : LoginsScreen();
              },
            ),
          );
        }

        return Text("Loading...");
      },
    );
  }
}
