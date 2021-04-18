import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/locale.modal.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("map")),
      ),
      body: Text(Provider.of<LocaleModel>(context).getString("map")),
    );
  }
}