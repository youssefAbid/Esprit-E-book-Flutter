import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/chapter.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/screens/details_screen.dart';
import 'package:esprit_ebook_app/widgets/book_rating.dart';
import 'package:esprit_ebook_app/widgets/rate_dialog.dart';
import 'package:esprit_ebook_app/widgets/readinf_today.dart';
import 'package:esprit_ebook_app/widgets/reading_card_list.dart';
import 'package:esprit_ebook_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeScreen({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String url = '${GlobalConfiguration().getString('img_server')}book/';
  List<Product> books = [];
  Product bestBook;
  Chapter currentReading = new Chapter();

  bool _isLoading = true;

  void loadPageInfo() async {
    final String url = '${GlobalConfiguration().getString('base_url')}home';
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
      print(jsonResponse["sectionOne"]);
      print(jsonResponse["sectionTwo"]);
      print(jsonResponse["sectionThree"]);
      if (jsonResponse != null) {
        setState(() {
          books = (jsonResponse["sectionOne"] as List)
              .map((data) => new Product.fromJSON(data))
              .toList();
          bestBook = Product.fromJSON(jsonResponse["sectionTwo"][0]);
          currentReading = Chapter.fromJsonDetails(
              jsonResponse["sectionThree"][0]["Chapter"]);
          print("------->" + currentReading.title);
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/main_page_bg.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: size.height * .1),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.display1,
                              children: [
                                TextSpan(text: "What are you \nreading "),
                                TextSpan(
                                    text: "today?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ReadingToDay(
                                books: books,
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.display1,
                                  children: [
                                    TextSpan(text: "Best of the "),
                                    TextSpan(
                                      text: "day",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : bestOfTheDayCard(size, context),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.display1,
                                  children: [
                                    TextSpan(text: "Continue "),
                                    TextSpan(
                                      text: "reading...",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 30, right: 20),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    _isLoading
                                                        ? Text("Waiting")
                                                        : Text(
                                                            currentReading
                                                                .title,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                    _isLoading
                                                        ? Text("Waiting")
                                                        : Text(
                                                            currentReading
                                                                .book.title,
                                                            style: TextStyle(
                                                              color:
                                                                  kLightBlackColor,
                                                            ),
                                                          ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: _isLoading
                                                          ? Text("Waiting")
                                                          : Text(
                                                              "Chapter " +
                                                                  currentReading
                                                                      .order
                                                                      .toString() +
                                                                  " of "+currentReading.book.totalChapter.toString(),
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color:
                                                                    kLightBlackColor,
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                              Image.network(
                                                url + currentReading.book.cover,
                                                width: 55,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 7,
                                        width: size.width * (currentReading
                                            .order / currentReading.book.totalChapter),
                                        decoration: BoxDecoration(
                                          color: kProgressIndicator,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 245,
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
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "New York Time Best For 11th March 2020",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  Text(
                    bestBook.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    bestBook.author,
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: InkWell(
                              onTap: () {
                                print("Hello");
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return RateDialog(
                                        book: bestBook.id,
                                      );
                                    });
                              },
                              child: BookRating(score: bestBook.rates)),
                        ),
                        Expanded(
                          child: Text(
                            bestBook.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.network(
              url+bestBook.cover,
              width: size.width * .37,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DetailsScreen(
                          parentScaffoldKey: widget.parentScaffoldKey,
                          book: bestBook,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
