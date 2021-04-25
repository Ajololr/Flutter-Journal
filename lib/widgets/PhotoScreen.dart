import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/types/Student.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';

class PhotoScreen extends StatefulWidget {
  final Student student;
  final int index;

  PhotoScreen({@required this.student, @required this.index}) : super();

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Provider.of<LocaleModel>(context).getString("galery")),
        ),
        body: Center(child: Image.network(
                widget.student.images[widget.index],
              ),) 
      ),
    );
  }
}
