import 'package:esprit_ebook_app/models/chapter.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/current_read_item.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentReadScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  CurrentReadScreen({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _CurrentReadScreenState createState() => _CurrentReadScreenState();
}

class _CurrentReadScreenState extends State<CurrentReadScreen> {
  Dialogs dialog = new Dialogs();
  List<Chapter> chapters = [];
  bool _isLoading = true;

  void loadPageInfo() async {
    final String url =
        '${GlobalConfiguration().getString('base_url')}currentread';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var jsonResponse = null;
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    });
    print("APi Response Status : " + response.statusCode.toString());
    print("APi Response : " + response.body.toString());
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          chapters = (jsonResponse["readCurrent"] as List)
              .map((data) => new Chapter.fromJsonDetails(data["Chapter"]))
              .toList();

          _isLoading = false;
        });
      }
    } else {
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
  }

  // void loadBookDetails() async {
  //   final String url =
  //       '${GlobalConfiguration().getString('base_url')}currentread';
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = sharedPreferences.get(key) ?? 0;
  //   print("Token From SP : " + value);
  //   var jsonResponse = null;
  //   var response = await http.get(url, headers: {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $value"
  //   });
  //   print("APi Response Status : " + response.statusCode.toString());
  //   print("APi Response : " + response.body.toString());
  //   jsonResponse = json.decode(response.body);
  //
  //   if (response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body);
  //     if (jsonResponse != null) {
  //       setState(() {
  //         chapters = (jsonResponse["readCurrent"] as List)
  //             .map((data) => new Chapter.fromJsonDetails(data["Chapter"]))
  //             .toList();
  //
  //         _isLoading = false;
  //       });
  //     }
  //   } else {
  //     dialog.information(
  //         context, "Échouer", "Probleme De Connection a Serveur");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadPageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? CircularProgressIndicator()
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Bitmap.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, top: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.import_contacts,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        'Current Chapter Read',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      subtitle: Text(
                        "Chapter That I am Reading",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: chapters.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return CurrentReadItem(
                            currentReading: chapters.elementAt(index));
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
