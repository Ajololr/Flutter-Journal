import 'package:flutter/material.dart';

class LoginsScreen extends StatefulWidget {
  LoginsScreen({Key key}) : super(key: key);

  @override
  _LoginsScreenState createState() => _LoginsScreenState();
}

class _LoginsScreenState extends State<LoginsScreen> {
  TextEditingController _passwordController;
  TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    print(_emailController.text + " " + _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 28),
              ),
              Column(
                children: [
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
                  InkWell(
                    child: Text("Add new groupmate"),
                    onTap: () {
                      print("Add new groupmate");
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
