import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/user.modal.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void _handleLogoutTap() {
    Provider.of<UserModel>(context, listen: false).toggleIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<LocaleModel>(context).getString("settings")),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: _handleLogoutTap,
              child: Icon(
                Icons.logout,
              ),
            ),
          )
        ],
      ),
      body: Text(Provider.of<LocaleModel>(context).getString("settings")),
    );
  }
}