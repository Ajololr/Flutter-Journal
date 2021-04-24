import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/types/Student.dart';
import 'package:flutter_group_journal/utils/firebase.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime currentDate = DateTime.now();
  File _image;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
      _birthdayController.text =
          DateFormat(DateFormat.YEAR_NUM_MONTH_DAY).format(pickedDate);
    }
  }

  Future getImage() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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


  void clearFields() {
    _passwordController.text = "";
    _emailController.text = "";
    _firstNameController.text = "";
    _lastNameController.text = "";
    _middleNameController.text = "";
    _birthdayController.text = "";

    setState(() {
      currentDate = DateTime.now();
      _image = null;
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

      var url = await FirebaseHelper.uploadImage(_image);
      await FirebaseHelper.addStudent(
          _firstNameController.text,
          _lastNameController.text,
          _middleNameController.text,
          [url],
          currentDate);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      clearFields();
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
              Column(
                children: [
                  InkWell(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: _image != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: FileImage(_image)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            )
                          : null,
                      child: _image == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 90,
                            )
                          : null,
                    ),
                    onTap: getImage,
                  ),
                  SizedBox(height: 20),
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
                    onTap: () => _selectDate(context),
                    readOnly: true,
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
