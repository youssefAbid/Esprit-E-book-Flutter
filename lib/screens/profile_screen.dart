
import 'package:esprit_ebook_app/models/user.dart';
import 'package:esprit_ebook_app/screens/avatar_screen.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/profile_avatar.dart';
import 'package:esprit_ebook_app/widgets/profile_setting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilScreen extends StatefulWidget {
  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Dialogs dialog = new Dialogs();
  final String urlimg ='${GlobalConfiguration().getString('img_server')}avatar/';

  editUser(User user) async {
    final String url = '${GlobalConfiguration().getString('base_url')}user';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    Map data = {
      'email': user.email,
      'phone': user.phone,
      'fname': user.fname,
      'lname': user.lname,
      'about': user.about,
    };
    print(data);
    var body = json.encode(data);
    var jsonResponse = null;
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $value"
        }, body: body);
    jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());

    if (response.statusCode == 200) {
      if (jsonResponse != null) {
        if (jsonResponse["status"] == "success") {
          setState(() {
            AppConfig.MAIN_USER.fname = jsonResponse["user"]["fname"];
            AppConfig.MAIN_USER.lname = jsonResponse["user"]["lname"];
            AppConfig.MAIN_USER.email = jsonResponse["user"]["email"];
            AppConfig.MAIN_USER.phone = jsonResponse["user"]["phone"];
            AppConfig.MAIN_USER.about = jsonResponse["user"]["about"];
          });
          print("-----------> DONE");
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => HomeScreen()),
          //         (Route<dynamic> route) => false);
        } else {
          dialog.information(context, "Échouer", "Probleme Dddd.");
        }
      }
    } else if (response.statusCode == 404) {
      dialog.information(context, "Échouer", "ُEmail Deja Existe");
    } else {
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    currentUser.value.email = AppConfig.MAIN_USER.email;
    currentUser.value.fname = AppConfig.MAIN_USER.fname;
    currentUser.value.lname = AppConfig.MAIN_USER.lname;
    currentUser.value.phone = AppConfig.MAIN_USER.phone;
    currentUser.value.about = AppConfig.MAIN_USER.about;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                AppConfig.MAIN_USER.fname+" "+AppConfig.MAIN_USER.lname,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                AppConfig.MAIN_USER.email,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        SizedBox(
                            width: 55,
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditAvatar();
                                    },
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(urlimg+AppConfig.MAIN_USER.avatar),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                           "Profile Settings",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: ButtonTheme(
                            padding: EdgeInsets.all(0),
                            minWidth: 50.0,
                            height: 25.0,
                            child: ProfileSettingsDialog(
                              user: currentUser.value,
                                onChanged: () {

                                    editUser(currentUser.value);

                                },
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "First Name",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            AppConfig.MAIN_USER.fname,
                            style: TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "Last Name",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            AppConfig.MAIN_USER.lname,
                            style: TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                           "Email",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            AppConfig.MAIN_USER.email,
                            style: TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "Phone",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            AppConfig.MAIN_USER.phone,
                            style: TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "About",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            AppConfig.MAIN_USER.about,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(color: Theme.of(context).focusColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(6),
                  //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
                  //   ),
                  //   child: ListView(
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     children: <Widget>[
                  //       ListTile(
                  //         leading: Icon(Icons.settings),
                  //         title: Text(
                  //           "Application Settings",
                  //           style: Theme.of(context).textTheme.bodyText1,
                  //         ),
                  //       ),
                  //       ListTile(
                  //         onTap: () {
                  //         },
                  //         dense: true,
                  //         title: Row(
                  //           children: <Widget>[
                  //             Icon(
                  //               Icons.translate,
                  //               size: 22,
                  //               color: Theme.of(context).focusColor,
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text(
                  //               'Languages',
                  //               style: Theme.of(context).textTheme.bodyText2,
                  //             ),
                  //           ],
                  //         ),
                  //         trailing: Text(
                  //           "english",
                  //           style: TextStyle(color: Theme.of(context).focusColor),
                  //         ),
                  //       ),
                  //       ListTile(
                  //         onTap: () {
                  //         },
                  //         dense: true,
                  //         title: Row(
                  //           children: <Widget>[
                  //             Icon(
                  //               Icons.place,
                  //               size: 22,
                  //               color: Theme.of(context).focusColor,
                  //             ),
                  //             SizedBox(width: 10),
                  //             Text(
                  //              'Delivery Addresses',
                  //               style: Theme.of(context).textTheme.bodyText2,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
