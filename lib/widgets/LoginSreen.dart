import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/models/user.modal.dart';
import 'package:flutter_group_journal/widgets/RegisterScreen.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginsScreen extends StatefulWidget {
  LoginsScreen({Key key}) : super(key: key);

  @override
  _LoginsScreenState createState() => _LoginsScreenState();
}

class _LoginsScreenState extends State<LoginsScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _passwordController;
  TextEditingController _emailController;
  String error;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    error = "";
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void setError(String errorMessage) {
    setState(() {
      error = errorMessage;
    });
  }

  void _onSubmit() async {
    try {
      setError("");

      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        setError(context.read<LocaleModel>().getString("err_empty"));
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Provider.of<UserModel>(context, listen: false).toggleIsLoggedIn();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setError(context.read<LocaleModel>().getString("err_email"));
      } else if (e.code == 'wrong-password') {
        setError(context.read<LocaleModel>().getString("err_password"));
      } else {
        setError(e.message);
      }
    }
  }

  void _navigateToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Provider.of<LocaleModel>(context).getString("login")),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                Provider.of<LocaleModel>(context).getString("welcome"),
                style: TextStyle(fontSize: 28),
              ),
              Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          Provider.of<LocaleModel>(context).getString("email"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("password"),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: _onSubmit,
                      child: Text(Provider.of<LocaleModel>(context)
                          .getString("login"))),
                  SizedBox(height: 20),
                  Text(error, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 20),
                  InkWell(
                    child: Text(Provider.of<LocaleModel>(context)
                        .getString("addGroupmate")),
                    onTap: _navigateToRegister,
                  )
                ],
              )
            ],
          ),
        ));
  }
}
