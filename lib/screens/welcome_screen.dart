import 'package:esprit_ebook_app/screens/home_screen.dart';
import 'package:esprit_ebook_app/screens/login_screen.dart';
import 'package:esprit_ebook_app/screens/pages_screen.dart';
import 'package:esprit_ebook_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isAuth = false;

  isAuthVerifier() async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      print('Awaiting user Auth...');
      final key = 'token';
      final value = sharedPreferences.getString(key) ?? "0";
      if (value != "0") {
        setState(() {
          isAuth = true;
        });
      }
      print(" --------> isAuth :" + isAuth.toString());
      print(" --------> SharedPreferences : " + value);
    } catch (err) {
      print('Caught error: $err');
    }
  }

  @override
  void initState() {
   // isAuthVerifier();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.display3,
                children: [
                  TextSpan(
                    text: "flamin",
                  ),
                  TextSpan(
                    text: "go.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: RoundedButton(
                text: "start reading",
                fontSize: 20,
                press: () {
                  if(isAuth){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Pages(currentTab: 1,);
                        },
                      ),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}