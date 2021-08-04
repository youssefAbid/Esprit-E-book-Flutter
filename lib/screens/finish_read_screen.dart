import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/finish.dart';
import 'package:esprit_ebook_app/models/order.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/screens/details_screen.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinishReadScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  FinishReadScreen({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _FinishReadScreenState createState() => _FinishReadScreenState();
}

class _FinishReadScreenState extends State<FinishReadScreen> {
  Dialogs dialog = new Dialogs();
  List<FinishRead> orders = [];
  bool _isLoading = true;

  Product bookDetails;

  void loadPageInfo() async {
    final String url = '${GlobalConfiguration().getString('base_url')}finish';
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
          orders = (jsonResponse as List)
              .map((data) => new FinishRead.fromJson(data))
              .toList();
          _isLoading = false;
        });
      }
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPageInfo();
  }



  void loadBookDetails(Product book) async {
    Map data = {'bookid': book.id};
    final String url = '${GlobalConfiguration().getString('base_url')}book';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    var body = json.encode(data);
    print("Token From SP : " + value);
    var jsonResponse = null;
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $value"
        },
        body: body);
    print("APi Response Status : " + response.statusCode.toString());
    print("APi Response : " + response.body.toString());
    jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        bookDetails = new Product.fromJSON(jsonResponse["book"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(book: bookDetails,);
            },
          ),
        );
      }
    } else {
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.library_books,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Books i Finished',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Books I Already Finish Reading",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myBookCard(size, context,orders.elementAt(index).book),
                    );
                },
              ),

              // child: ListView(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: myBookCard(size, context),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: myBookCard(size, context),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: myBookCard(size, context),
              //     ),
              //   ],
              //),
            )
          ],
        ),
      ),
    );
  }


  Container myBookCard(Size size, BuildContext context,Product book) {
    final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      height: 185,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.7),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    book.author,
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  SizedBox(height: 7,),
                  Text(
                    book.description,
                    maxLines: 5,
                    style: TextStyle(color: kTextBlackColor,fontSize: 10),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.network(
              urlimg+book.cover,
              width: size.width * .37,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(38.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment:
                            Alignment.bottomRight,
                            child: Text(
                              "Total Chapters : "+book.totalChapter.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: kLightBlackColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 7,
                    width: size.width * .80,
                    decoration: BoxDecoration(
                      color: kProgressIndicator,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Details",
                radious: 24,
                press: () {



                  loadBookDetails(book);



                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}
