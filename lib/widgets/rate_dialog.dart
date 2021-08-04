import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RateDialog extends StatefulWidget {
  int book;
  RateDialog({Key key, @required this.book}) : super(key: key);
  @override
  _RateDialogState createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {


  void addRate(int id,double rate,BuildContext context) async {
    Map data = {'id': id,'rate':rate};
    final String url = '${GlobalConfiguration().getString('base_url')}rate';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var body = json.encode(data);
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $value"
        },
        body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("Result : " + jsonResponse.toString());
      Navigator.pop(context);
    }
  }


  double _value=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Dialog(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 139, 198, 0.3),
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    )
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Rate',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      child: Text('Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                          )),
                      color: Color.fromRGBO(110, 120, 247, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      onPressed: () => addRate(widget.book,double.parse(AppConfig.rateFormat(_value)),context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(AppConfig.rateFormat(_value)),
                  ),
                  Slider(
                    min: 0,
                    max: 5,
                    value: _value,
                    onChanged: (value){
                      setState(() {
                        _value = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
