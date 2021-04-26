import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_group_journal/types/Student.dart';
import 'package:flutter_group_journal/utils/firebase.dart';
import 'package:flutter_group_journal/widgets/StudentScreen.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({Key key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Student> students = [];
  List<Student> duplicateStudents = [];
  TextEditingController _searchController;

  @override
  void initState() {
    loadStudents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadStudents() async {
    var students = await FirebaseHelper.getAllStudents();
    setStudents(students);
  }

  setStudents(List<Student> loaded) {
    setState(() {
      students.addAll(loaded);
      duplicateStudents.addAll(loaded);
    });
  }

  void rerender() {
    setState(() {});
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Student> dummyListData = [];
      duplicateStudents.forEach((item) {
        if (("${item.firstName} ${item.lastName} ${item.secondName}")
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        students.clear();
        students.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        students.clear();
        students.addAll(duplicateStudents);
      });
    }
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
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  labelText:
                      Provider.of<LocaleModel>(context).getString("search"),
                  hintText:
                      Provider.of<LocaleModel>(context).getString("search"),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)))),
              onChanged: (value) {
                filterSearchResults(value);
              },
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) => InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => StudentSceen(
                            student: students[index],
                            rerender: this.rerender))),
                child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image(
                                  image:
                                      NetworkImage(students[index].images[0]),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      students[index].firstName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      students[index].lastName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      students[index].secondName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Birthday: " +
                                          DateFormat(
                                                  DateFormat.YEAR_NUM_MONTH_DAY)
                                              .format(students[index].birthday),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )))),
          ))
        ],
      ),
    );
  }
}
