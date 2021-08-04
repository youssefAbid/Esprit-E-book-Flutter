import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/screens/login_screen.dart';
import 'package:esprit_ebook_app/screens/pages_screen.dart';
import 'package:esprit_ebook_app/screens/profile_screen.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final String url ='${GlobalConfiguration().getString('img_server')}avatar/';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilScreen();
                    },
                  ),
                );
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.1),
                ),
                accountName: Text(
                  AppConfig.MAIN_USER.fname+" "+AppConfig.MAIN_USER.lname,
                  style: Theme.of(context).textTheme.headline6,
                ),
                accountEmail: Text(
                  "Points : "+AppConfig.MAIN_USER.point.toString(),
                  style: Theme.of(context).textTheme.caption,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: kIconColor,
                  backgroundImage: NetworkImage(url+AppConfig.MAIN_USER.avatar),
                ),
              )),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pages(
                      currentTab: 1,
                    );
                  },
                ),
              );
            },
            leading: Icon(
              Icons.home,
              color: kProgressIndicator,
            ),
            title: Text(
              "Home",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pages(
                      currentTab: 4,
                    );
                  },
                ),
              );
            },
            leading: Icon(
              Icons.favorite,
              color: kProgressIndicator,
            ),
            title: Text(
              "Favories",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pages(
                      currentTab: 6,
                    );
                  },
                ),
              );
            },
            leading: Icon(
              Icons.book,
              color: kProgressIndicator,
            ),
            title: Text(
              "Book Finish Reading",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pages(
                      currentTab: 3,
                    );
                  },
                ),
              );
            },
            leading: Icon(
              Icons.search,
              color: kProgressIndicator,
            ),
            title: Text(
              "Search",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Pages(
                      currentTab: 5,
                    );
                  },
                ),
              );
            },
            leading: Icon(
              Icons.border_top,
              color: kProgressIndicator,
            ),
            title: Text(
              "Top Readers",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Application Preferences",
              style: TextStyle(color:kProgressIndicator ),
            ),
            trailing: Icon(
              Icons.remove,
              color: kProgressIndicator.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()),
                  (Route<dynamic> route) => false);
            },
            leading: Icon(
              Icons.exit_to_app,
              color: kProgressIndicator,
            ),
            title: Text(
              "Log Out",
              style: TextStyle(color:kProgressIndicator ),
            ),
          ),
        ],
      ),
    );
  }
}
