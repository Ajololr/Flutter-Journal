import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_group_journal/utils/firebase.dart';
import 'package:flutter_group_journal/widgets/GaleryScreen.dart';
import 'package:flutter_group_journal/widgets/VideoScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/types/Student.dart';

class StudentSceen extends StatefulWidget {
  final Student student;

  StudentSceen({@required this.student}) : super();

  @override
  _StudentSceenState createState() => _StudentSceenState();
}

class _StudentSceenState extends State<StudentSceen> {
  DateTime currentDate = DateTime.now();
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
    _latitudeController = TextEditingController(text: widget.student.latitude);
    _longitudeController =
        TextEditingController(text: widget.student.longitude);
    _firstNameController =
        TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _middleNameController =
        TextEditingController(text: widget.student.secondName);
    _birthdayController = TextEditingController(
        text: DateFormat(DateFormat.YEAR_NUM_MONTH_DAY)
            .format(widget.student.birthday));
    result = "";
    resultColor = Colors.transparent;
    currentDate = widget.student.birthday;
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
      result = context.read<LocaleModel>().getString("groupmate_edit_success");
      resultColor = Colors.green;
    });
  }

  Future _selectVideo() async {
    final pickedFile = await ImagePicker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File _video = File(pickedFile.path);
      String url = await FirebaseHelper.uploadVideo(_video);
      widget.student.videoUrl = url;
      FirebaseHelper.updateStudent(widget.student);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate.isAfter(DateTime.now()) ? DateTime.now() :currentDate,
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

      widget.student.firstName = _firstNameController.text;
      widget.student.lastName = _lastNameController.text;
      widget.student.secondName = _middleNameController.text;
      widget.student.latitude = _latitudeController.text;
      widget.student.longitude = _longitudeController.text;
      widget.student.birthday = currentDate;

      await FirebaseHelper.updateStudent(widget.student);
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
        floatingActionButton: FloatingActionButton(
          onPressed: _onSubmit,
          child: const Icon(Icons.check),
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
                  labelText:
                      Provider.of<LocaleModel>(context).getString("firstName"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      Provider.of<LocaleModel>(context).getString("lastName"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _middleNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText:
                      Provider.of<LocaleModel>(context).getString("middleName"),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _birthdayController,
                readOnly: true,
                onTap: () => _selectDate(context),
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
                        labelText: Provider.of<LocaleModel>(context)
                            .getString("latitude"),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: TextField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Provider.of<LocaleModel>(context)
                            .getString("longitude"),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => widget.student.videoUrl.isEmpty
                          ? null
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VideoScreen(
                                          videoUrl: widget.student.videoUrl))),
                      child: Text(Provider.of<LocaleModel>(context)
                          .getString("watch_video"))),
                  ElevatedButton(
                      onPressed: _selectVideo,
                      child: Text(Provider.of<LocaleModel>(context)
                          .getString("select_video"))),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                GaleryScreen(student: widget.student))),
                    child: Text(
                        Provider.of<LocaleModel>(context).getString("galery"))),
              ),
              SizedBox(height: 20),
              Text(result, style: TextStyle(color: resultColor)),
            ],
          ),
        ));
  }
}
