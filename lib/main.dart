import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/models/user.modal.dart';
import 'package:flutter_group_journal/widgets/loginSreen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => LocaleModel(context)),
    ],
    child: App(),    
  )
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
