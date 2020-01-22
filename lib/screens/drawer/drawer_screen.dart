import 'package:flutter/material.dart';
import 'package:weather_application/utils/navigator_shortcut.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);

    return SafeArea(
      child: Container(
        width: 300,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "Wlad'myr Almeida",
                style: TextStyle(fontSize: 20.0, color: _theme.accentColor),
              ),
              accountEmail: Text(
                "wladmyralmeida@gmail.com",
                style: TextStyle(
                  fontSize: 10.0,
                  color: _theme.accentColor,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: Icon(
                  Icons.ac_unit,
                  size: 45.0,
                ),
                backgroundColor: _theme.primaryColorDark,
                foregroundColor: _theme.canvasColor,
              ),
            ),
            ListTile(
              onTap: () {
                print("Tela Principal");
                pop(context, "");
              },
              title: Text("Principal"),
              leading: Icon(Icons.star),
            ),
            ListTile(
              onTap: () {
                print("Climas");
                pop(context);
              },
              title: Text("Climas"),
              leading: Icon(Icons.whatshot),
            ),
            ListTile(
              onTap: () {
                print("Configurações");
              },
              title: Text("Configurações"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              onTap: () {},
              title: Text("Visite o site"),
              leading: Icon(Icons.web),
            ),
            ListTile(
              onTap: () {
                print("Ajuda");
              },
              title: Text("Ajuda"),
              leading: Icon(Icons.help),
            ),
            ListTile(
              onTap: () {
                pop(context, "");
              },
              title: Text("Logout"),
              leading: Icon(Icons.close),
            )
          ],
        ),
      ),
    );
  }
}
