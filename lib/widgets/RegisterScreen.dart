import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _passwordController;
  TextEditingController _emailController;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _middleNameController;
  TextEditingController _birthdayController;
  String result;
  Color resultColor;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _birthdayController = TextEditingController();
    result = "";
    resultColor = Colors.transparent;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void setError(String message) {
    setState(() {
      result = message;
      resultColor = Colors.red;
    });
  }

  void setSuccess() {
    setState(() {
      result = context.read<LocaleModel>().getString("groupmateAddSuccess");
      resultColor = Colors.green;
    });
  }

  void _onSubmit() async {
    try {
      setError("");

      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _middleNameController.text.isEmpty ||
          _birthdayController.text.isEmpty) {
        setError(context.read<LocaleModel>().getString("err_empty"));
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      setSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError(context.read<LocaleModel>().getString("err_week_password"));
      } else if (e.code == 'email-already-in-use') {
        setError(context.read<LocaleModel>().getString("err_email_in_use"));
      } else {
        setError(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(Provider.of<LocaleModel>(context).getString("addGroupmate")),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Placeholder!',
                style: TextStyle(fontSize: 28),
              ),
              Column(
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("firstName"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("lastName"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _middleNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("middleName"),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _birthdayController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Provider.of<LocaleModel>(context)
                          .getString("birthday"),
                    ),
                  ),
                  SizedBox(height: 20),
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
                      child: Text(
                          Provider.of<LocaleModel>(context).getString("add"))),
                  SizedBox(height: 20),
                  Text(result, style: TextStyle(color: resultColor))
                ],
              )
            ],
          ),
        ));
  }
}
