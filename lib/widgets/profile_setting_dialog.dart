import 'package:esprit_ebook_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileSettingsDialog extends StatefulWidget {
  User user;
  final VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged}) : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog> {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();

  // editUser(User user) async {
  //   final String url = '${GlobalConfiguration().getString('base_url')}user';
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = sharedPreferences.get(key) ?? 0;
  //   print("Token From SP : " + value);
  //   Map data = {
  //     'email': user.email,
  //     'phone': user.phone,
  //     'fname': user.fname,
  //     'lname': user.lname,
  //     'about': user.about,
  //   };
  //   print(data);
  //   var body = json.encode(data);
  //   var jsonResponse = null;
  //   var response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $value"
  //       }, body: body);
  //   jsonResponse = json.decode(response.body);
  //   print(jsonResponse.toString());
  //   //
  //   // if (response.statusCode == 200) {
  //   //   if (jsonResponse != null) {
  //   //     if (jsonResponse["token"]["id"] != null) {
  //   //       AppConfig.MAIN_USER = User.fromJson(jsonResponse);
  //   //       print("-----------> DONE");
  //   //       sharedPreferences.setString(
  //   //           "userid", AppConfig.MAIN_USER.id.toString());
  //   //       sharedPreferences.setString("token", AppConfig.MAIN_USER.token.token);
  //   //       // Navigator.of(context).pushAndRemoveUntil(
  //   //       //     MaterialPageRoute(
  //   //       //         builder: (BuildContext context) => HomeScreen()),
  //   //       //         (Route<dynamic> route) => false);
  //   //     } else {
  //   //       dialog.information(context, "Échouer", "Probleme Dddd.");
  //   //     }
  //   //   }
  //   // } else if (response.statusCode == 404) {
  //   //   dialog.information(context, "Échouer", "ُEmail Deja Existe");
  //   // } else {
  //   //   dialog.information(
  //   //       context, "Échouer", "Probleme De Connection a Serveur");
  //   // }
  // }


  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      "Profile Settings",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: "name", labelText: "First Name"),
                          initialValue: widget.user.fname,
                          validator: (input) => input.trim().length < 3 ? "not_a_valid_full_name" : null,
                          onSaved: (input){
                            setState(() {
                              widget.user.fname = input;
                            });
                          },
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: "name", labelText: "Last Name"),
                          initialValue: widget.user.lname,
                            validator: (input) => input.trim().length < 3 ? "not_a_valid_full_name" : null,
                            onSaved: (input) => widget.user.lname = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(hintText: 'email@gmail.com', labelText: "Email"),
                          initialValue: widget.user.email,
                          onSaved: (input) => widget.user.email = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: '+123 456 7890', labelText: "Phone Number"),
                          initialValue: widget.user.phone,
                          validator: (input) => input.trim().length < 3 ? "not_a_valid_phone" : null,
                          onSaved: (input) => widget.user.phone = input,
                        ),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).hintColor),
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(hintText: "your_biography", labelText: "About Me"),
                          initialValue: widget.user.about,
                          validator: (input) => input.trim().length < 3 ? "not_a_valid_biography" : null,
                          onSaved: (input){
                            setState(() {
                              widget.user.about = input;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      MaterialButton(
                        onPressed:_submit,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Theme.of(context).accentColor),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        "Edit",
        style: Theme.of(context).textTheme.bodyText2,
      ),


    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).focusColor),
      ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }


  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      print("-----------> "+widget.user.fname);
      widget.onChanged();

      Navigator.pop(context);
    }
  }
}



