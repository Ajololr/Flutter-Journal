import 'package:flutter/material.dart';
import 'package:flutter_group_journal/utils/firebase.dart';
import 'package:flutter_group_journal/widgets/PhotoScreen.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_group_journal/types/Student.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';

class GaleryScreen extends StatefulWidget {
  final Student student;

  GaleryScreen({@required this.student}) : super();

  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  void _addPhoto() async {
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var url = await FirebaseHelper.uploadImage(pickedFile);
      widget.student.images.add(url);
      FirebaseHelper.updateStudent(widget.student);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Provider.of<LocaleModel>(context).getString("galery")),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(widget.student.images.length, (index) {
            return Center(
              child: InkWell(
                child:Image.network(
                  widget.student.images[index],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                      PhotoScreen(student: widget.student, index: index,))),
              ), 
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addPhoto,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
