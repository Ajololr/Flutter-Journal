import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_group_journal/models/user.modal.dart';
import 'package:flutter_group_journal/models/locale.modal.dart';
import 'package:flutter_group_journal/models/theme.model.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale _lang = Locale.en;

  void _handleLogoutTap() {
    Provider.of<UserModel>(context, listen: false).toggleIsLoggedIn();
  }

  void _onLangChanged(Locale value) {
    setState(() {
      _lang = value;
    });
    Provider.of<LocaleModel>(context, listen: false).setLocale(value);
  }

  void _onThemeChanged(bool isDark) {
    isDark
        ? Provider.of<ThemeModel>(context, listen: false).setDarkMode()
        : Provider.of<ThemeModel>(context, listen: false).setLightMode();
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
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Provider.of<LocaleModel>(context).getString("lang")),
                  Container(
                    width: 200,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(Provider.of<LocaleModel>(context)
                              .getString("lang_ru")),
                          leading: Radio<Locale>(
                            value: Locale.ru,
                            groupValue: _lang,
                            onChanged: _onLangChanged,
                          ),
                        ),
                        ListTile(
                          title: Text(Provider.of<LocaleModel>(context)
                              .getString("lang_en")),
                          leading: Radio<Locale>(
                            value: Locale.en,
                            groupValue: _lang,
                            onChanged: _onLangChanged,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Provider.of<LocaleModel>(context)
                      .getString("dark_theme")),
                  Switch(
                      value: Provider.of<ThemeModel>(context).isDark,
                      onChanged: _onThemeChanged),
                ],
              ),
            ],
          ),
        ));
  }
}
