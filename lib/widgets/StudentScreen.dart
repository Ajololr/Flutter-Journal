import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';

import 'package:flutter_group_journal/types/Student.dart';

class StudentSceen extends StatefulWidget {
  final Student student;

  StudentSceen({@required this.student}) : super();

  @override
  _StudentSceenState createState() => _StudentSceenState();
}

class _StudentSceenState extends State<StudentSceen> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _middleNameController;
  TextEditingController _birthdayController;
  TextEditingController _latitudeController;
  TextEditingController _longitudeController;
  String result = "";
  Color resultColor;

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController(text: widget.student.lattitude);
    _longitudeController = TextEditingController(text: widget.student.longitude);
    _firstNameController = TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _middleNameController = TextEditingController(text: widget.student.secondName);
    _birthdayController = TextEditingController(text: widget.student.birthday.toString());
    result = "";
    resultColor = Colors.transparent;
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
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

      if (_longitudeController.text.isEmpty ||
          _latitudeController.text.isEmpty ||
          _firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _middleNameController.text.isEmpty ||
          _birthdayController.text.isEmpty) {
        setError(context.read<LocaleModel>().getString("err_empty"));
        return;
      }

      setSuccess();
    } catch (e) {
      setError(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.student.firstName} ${widget.student.lastName}"),
      ),
      body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      labelText:
                          Provider.of<LocaleModel>(context).getString("birthday"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _latitudeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                Provider.of<LocaleModel>(context).getString("latitude"),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: TextField(
                          controller: _longitudeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                Provider.of<LocaleModel>(context).getString("longitude"),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(Provider.of<LocaleModel>(context).getString("save"))
                  ),
                  SizedBox(height: 20),
                  Text(result, style: TextStyle(color: resultColor)),
            ],
          ),
        )
      );
  }
}
