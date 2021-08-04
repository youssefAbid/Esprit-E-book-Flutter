import 'package:esprit_ebook_app/data_static.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/cart_bottom_details.dart';
import 'package:esprit_ebook_app/widgets/cart_item.dart';
import 'package:esprit_ebook_app/widgets/favorie_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavorieScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  FavorieScreen({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _FavorieScreenState createState() => _FavorieScreenState();
}

class _FavorieScreenState extends State<FavorieScreen> {
  Dialogs dialog = new Dialogs();
  List<Product> books = [];
  bool _isLoading = true;
  void loadPageInfo() async {
    final String url = '${GlobalConfiguration().getString('base_url')}fav';
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
          books = (jsonResponse["books"] as List)
              .map((data) => new Product.fromJSON(data))
              .toList();
          print("--------------> "+books.length.toString());
          _isLoading = false;
        });
      }
    } else {
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPageInfo();
  }


  void removeFavBook(Product book) async {
    Map data = {'id': book.id};
    setState(() {
      books.remove(book);
    });
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
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.favorite,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Favorite Books',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Check And Remove your Favorite Books",
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
                itemCount: books.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return FavorieItemWidget(
                    cart: books.elementAt(index),
                    heroTag: 'cart',
                    onDismissed: (){
                      removeFavBook(books.elementAt(index));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
