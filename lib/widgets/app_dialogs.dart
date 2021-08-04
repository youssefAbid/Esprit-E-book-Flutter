import 'package:flutter/material.dart';
class Dialogs {
  information(BuildContext context, String title, String description) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(description)],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () => Navigator.pop(context), child: Text("Okay"))
            ],
          );
        });
  }

  ratingBox(BuildContext context, String title, String description) {
    double _value=0;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Text(_value.toString()),
                  Slider(
                    min: 0,
                    max: 5,
                    value: _value,
                    onChanged: (value){

                      _value = value;
                    },
                  )

                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () => Navigator.pop(context), child: Text("Okay"))
            ],
          );
        });
  }
}