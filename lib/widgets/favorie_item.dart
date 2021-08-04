import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/cart.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FavorieItemWidget extends StatefulWidget {
  String heroTag;
  Product cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;
  FavorieItemWidget(
      {Key key,
      this.cart,
      this.heroTag,
      this.increment,
      this.decrement,this.onDismissed})
      : super(key: key);

  @override
  _FavorieItemWidgetState createState() => _FavorieItemWidgetState();
}

class _FavorieItemWidgetState extends State<FavorieItemWidget> {
  final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
  void removeFavBook(int bookId) async {
    Map data = {'id': bookId};
    final String url = '${GlobalConfiguration().getString('base_url')}refav';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var body = json.encode(data);
    var jsonResponse = null;
    var response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    },body:body );
    print("APi Response Status : " + response.statusCode.toString());
    print("APi Response : " + response.body.toString());
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
    } else {
      print(jsonResponse);
    }
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dismissible(
      key: Key(widget.cart.id.toString()),
      onDismissed: (direction) {
        // print(widget.cart.id);
        // print(widget.cart.title);
        // removeFavBook(widget.cart.id);
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(38.5),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 33,
                color: Color(0xFFD3D3D3).withOpacity(.84),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(38.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.network(
                          urlimg+widget.cart.cover,
                          width: 55,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.cart.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.cart.author,
                                style: TextStyle(
                                  color: kLightBlackColor,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.increment();
                              });
                            },
                            iconSize: 40,
                            //padding: EdgeInsets.symmetric(horizontal: 5),
                            icon: Icon(Icons.favorite),
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

/*


        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.increment();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                      Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subtitle1),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.decrement();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.remove_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),

*/
      ),
    );
  }
}
