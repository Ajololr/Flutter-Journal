import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
      result = "New groupmate added";
      resultColor = Colors.green;
    });
  }

  void _onSubmit() {
    setSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new groupmate"),
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
                      labelText: 'First name',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last name',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _middleNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Middle name',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _birthdayController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Birthday',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(onPressed: _onSubmit, child: Text("Login")),
                  SizedBox(height: 20),
                  Text(result, style: TextStyle(color: resultColor))
                ],
              )
            ],
          ),
        ));
  }
}
