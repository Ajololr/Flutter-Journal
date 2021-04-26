import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_group_journal/models/theme.model.dart';
import 'package:flutter_group_journal/types/Student.dart';
import 'package:flutter_group_journal/utils/firebase.dart';
import 'package:flutter_group_journal/widgets/StudentScreen.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_group_journal/models/locale.modal.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  List<Student> students = [];
  String _mapStyle;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.9006, 27.5590),
    zoom: 8,
  );

  @override
  void initState() {
    loadStudents();
    super.initState();
    rootBundle.loadString('assets/map/dark.json').then((string) {
      _mapStyle = string;
    });
  }

  loadStudents() async {
    var loaded = await FirebaseHelper.getAllStudents();
    setState(() {
      students = loaded;
    });
  }

  LatLng _getLatLng(Student student) {
    try {
      double lat = double.parse(student.latitude);
      double lng = double.parse(student.longitude);
      return new LatLng(lat, lng);
    } catch (e) {
      return new LatLng(0, 0);
    }
  }

  void rerender() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("map")),
      ),
      body: GoogleMap(
        // mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          if (Provider.of<ThemeModel>(context, listen: false).isDark) {
            controller.setMapStyle(_mapStyle);
          }
          _controller.complete(controller);
        },
        markers: students
            .map((student) => Marker(
                  markerId: new MarkerId(student.id),
                  position: _getLatLng(student),
                  infoWindow: InfoWindow(
                      title: "${student.firstName} ${student.lastName}",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => StudentSceen(
                                    student: student,
                                    rerender: this.rerender,
                                  )))),
                ))
            .toSet(),
      ),
    );
  }
}
