import 'package:flutter/material.dart';
import 'package:flutter_group_journal/types/Student.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({Key key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('group mates');
  List<Student> students = [];

  @override
  void initState() {
    // students = [];
    loadStudents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadStudents() async {
    var data = await users.get();
    var a = data.docs.map<Student>((doc) => new Student(
          doc.get("firstName"),
          doc.get("lastName"),
          doc.get("secondName"),
          (doc.get("images") as List<String>),
          doc.get("birthday").toDate(),
          doc.get("lattitude"),
          doc.get("longitude"),
          doc.get("videoUrl"),
        ));
    print(a);
    // List<Student> students = a.toList();
    setStudents(students);
  }

  setStudents(List<Student> loaded) {
    setState(() {
      students = loaded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("group")),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: 220,
                    width: double.maxFinite,
                    child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Row(
                          children: [
                            Container(
                              height: 220,
                              child: Image.network(students[index].images[0]),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(students[index].firstName),
                                  SizedBox(height: 10),
                                  Text(students[index].lastName),
                                  SizedBox(height: 10),
                                  Text(students[index].secondName),
                                  SizedBox(height: 10),
                                  Text("Birthday: " +
                                      DateFormat(DateFormat.YEAR_NUM_MONTH_DAY)
                                          .format(students[index].birthday))
                                ],
                              ),
                            )
                          ],
                        )))),
          )
        ],
      ),
    );
  }
}
