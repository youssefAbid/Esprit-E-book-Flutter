import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/user.dart';
import 'package:esprit_ebook_app/screens/home_screen.dart';
import 'package:esprit_ebook_app/screens/login_screen.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:esprit_ebook_app/utils/app_validation.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Dialogs dialog = new Dialogs();
  final TextEditingController fnameController = new TextEditingController();
  final TextEditingController lnameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool showpass = true;

  signUp(String email, String password, String fname, String lname) async {
    final String url = '${GlobalConfiguration().getString('base_url')}signup';
    Map data = {
      'email': email,
      'password': password,
      'fname': fname,
      'lname': lname,
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var body = json.encode(data);
    var jsonResponse = null;
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    jsonResponse = json.decode(response.body);
    print(jsonResponse.toString());

    if (response.statusCode == 201) {
      if (jsonResponse != null) {
        if (jsonResponse["token"]["id"] != null) {
          AppConfig.MAIN_USER = User.fromJson(jsonResponse);
          print("-----------> DONE");
          sharedPreferences.setString(
              "userid", AppConfig.MAIN_USER.id.toString());
          sharedPreferences.setString("token", AppConfig.MAIN_USER.token.token);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
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
  Widget build(BuildContext context) {
    MediaQueryData _queryData = MediaQuery.of(context);
    double _height = _queryData.size.height / 100.0;
    double _width = _queryData.size.width / 100.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child:
            Container(
              child: Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
          Positioned(
              top: 0,
              child: Container(
                width: (_width * 100),
                height: (_height * 37),
                // decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
          ),
          Positioned(
              top: (_height * 37) - 160,
              child: Container(
                width: (_width * 84),
                height: (_height * 37),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.display1,
                    children: [
                      TextSpan(
                        text: "Lets Start With",
                      ),
                      TextSpan(
                        text: " Register!",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          Positioned(
              top: (_height * 37) - 80,
              child: Container(
                margin: EdgeInsets.only(left: 24, right: 24, bottom: 40),
                height: 475,
                width: 312,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 450,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(29),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 33,
                              color: kShadowColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // SizedBox(height: 20),
                            TextFormField(
                              controller: fnameController,
                              keyboardType: TextInputType.text,
                              validator: (input) => input.length < 3
                                  ? 'should_be_more_than_3_letters'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(color: kProgressIndicator),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'SaifEddine',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: Icon(Icons.person_outline,
                                    color: kProgressIndicator),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: lnameController,
                              keyboardType: TextInputType.text,
                              validator: (input) => input.length < 3
                                  ? 'should_be_more_than_3_letters'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(color: kProgressIndicator),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'Rhouma',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: Icon(Icons.person_outline,
                                    color: kProgressIndicator),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: kProgressIndicator),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'saif.rhouma@gmail.com',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: Icon(Icons.alternate_email,
                                    color: kProgressIndicator),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              obscureText: showpass,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: kProgressIndicator),
                                contentPadding: EdgeInsets.all(12),
                                hintText: '••••••••••••',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: kProgressIndicator),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print("-----------> " + showpass.toString());
                                    setState(() {
                                      showpass = !showpass;
                                      print(
                                          "-----------> " + showpass.toString());
                                    });
                                  },
                                  color: Theme.of(context).focusColor,
                                  icon: showpass
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            kProgressIndicator.withOpacity(0.2))),
                              ),
                            ),
                            SizedBox(height: 30),
                            FlatButton(
                              onPressed: () {
                                if(!AppValidation.namesValidation(fnameController.text)){
                                  dialog.information(context, "Échouer",
                                      "Vérifier votre Prenom SVP.");
                                }else if (!AppValidation.namesValidation(
                                    lnameController.text)) {
                                  dialog.information(context, "Échouer",
                                      "Vérifier votre Nom SVP.");
                                }else if (!AppValidation.emailValidation(
                                    emailController.text)) {
                                  dialog.information(context, "Échouer",
                                      "Vérifier votre Email SVP.");
                                } else {
                                  if (AppValidation.passwordValidationLogin(
                                    passwordController.text,
                                  )) {
                                    dialog.information(context, "Échouer",
                                        "Vérifier votre Mot de Passe SVP.");
                                  } else {
                                    signUp(
                                      emailController.text,
                                      passwordController.text,
                                      fnameController.text,
                                      lnameController.text,
                                    );
                                  }
                                }
                              },
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              child: Text("Register"),
                              color: kProgressIndicator,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 390,
                      child: Container(
                        height: 85,
                        width: 312,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              children: <Widget>[
                                //Spacer(),
                                SizedBox(
                                  width: 60,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return LoginScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: TwoSideRoundedButton(
                                      text: "Already Have Account",
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
        ]),
            ),
      ),
    );
  }
}
