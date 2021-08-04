import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/data_static.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/screens/details_screen.dart';
import 'package:esprit_ebook_app/widgets/favorie_item.dart';
import 'package:esprit_ebook_app/widgets/search_item.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  SearchScreen({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> _search = [];
  bool start = false;
  var loading = true;

  void fetchData(String search) async {
    Map data = {'search': search};
    final String url = '${GlobalConfiguration().getString('base_url')}search';
    setState(() {
      loading = false;
    });
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
      setState(() {
        _search = (jsonResponse as List)
            .map((data) => new Product.fromJSON(data))
            .toList();
        loading = false;
      });
    }
  }

  TextEditingController searchController = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    setState(() {});
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
                  Icons.search,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Search Books',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5,
                ),
                subtitle: Text(
                  "Search Books By Name And Author",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(right: 24, left: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.6),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 7),
                    blurRadius: 20,
                    color: Color(0xFD3D3D3).withOpacity(.5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 20),
                    child: Icon(Icons.search, color: kProgressIndicator),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        print(value);
                        fetchData(value);
                      },
                      decoration:
                          InputDecoration.collapsed(hintText: "Book Name..."),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(fontSize: 14)),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 12, left: 5, top: 3, bottom: 3),
                      child: Icon(Icons.filter_list, color: kProgressIndicator),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 15),
                itemCount: _search.length,
                itemBuilder: (context, index) {
                  return SearchItemWedget(
                    image: _search.elementAt(index).cover,
                    title: _search.elementAt(index).title,
                    auth: _search.elementAt(index).author,
                    rating: _search.elementAt(index).rates,
                    pressDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailsScreen(book: _search.elementAt(index),);
                          },
                        ),
                      );
                    },
                  );
                },
              ),

              // child: ListView(
              //   children: <Widget>[
              //     SearchItemWedget(
              //       image: "assets/images/book-1.png",
              //       title: "Crushing & Influence & CDInfluence",
              //       auth: "Gary Venchuk",
              //       rating: 4.9,
              //       pressDetails: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) {
              //               return DetailsScreen();
              //             },
              //           ),
              //         );
              //       },
              //     ),
              //     SearchItemWedget(
              //       image: "assets/images/book-1.png",
              //       title: "Crushing & Influence & CDInfluence",
              //       auth: "Gary Venchuk",
              //       rating: 4.9,
              //       pressDetails: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) {
              //               return DetailsScreen();
              //             },
              //           ),
              //         );
              //       },
              //     ),
              //     SearchItemWedget(
              //       image: "assets/images/book-1.png",
              //       title: "Crushing & Influence & CDInfluence",
              //       auth: "Gary Venchuk",
              //       rating: 4.9,
              //       pressDetails: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) {
              //               return DetailsScreen();
              //             },
              //           ),
              //         );
              //       },
              //     ),
              //     SearchItemWedget(
              //       image: "assets/images/book-1.png",
              //       title: "Crushing & Influence & CDInfluence",
              //       auth: "Gary Venchuk",
              //       rating: 4.9,
              //       pressDetails: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) {
              //               return DetailsScreen();
              //             },
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
