import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({Key key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("group")),
      ),
      body: Text(Provider.of<LocaleModel>(context).getString("group")),
    );
  }
}