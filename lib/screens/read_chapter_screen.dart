import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/chapter.dart';
import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/models/user.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadChapter extends StatefulWidget {
  Product book;
  int bookChaptres;
  List<Chapter> chapters;
  int index;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ReadChapter(
      {Key key,
      this.parentScaffoldKey,
      this.book,
      this.chapters,
      this.bookChaptres,
      this.index})
      : super(key: key);

  @override
  _ReadChapterState createState() => _ReadChapterState();
}

class _ReadChapterState extends State<ReadChapter> {
  final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
  bool _isLoading = true;
  bool _isLoadingPDF = true;
  int currentChapter;
  PDFDocument doc;

  void loadPdfChapter(Chapter chapter) async {
    final String url =
        '${GlobalConfiguration().getString('base_url')}readpdf/' +
            chapter.id.toString() +
            "/" +
            AppConfig.MAIN_USER.id.toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    print("Pdf Url : " + url);
    // var response = await http.get(url, headers: {
    //   "Content-Type": "application/json",
    //   "Authorization": "Bearer $value"
    // });
    doc = await PDFDocument.fromURL(url);
    setState(() {
      _isLoading = false;
      _isLoadingPDF = false;
    });
  }

  void loadComplete(Chapter chapter) async {
    final String url =
        '${GlobalConfiguration().getString('base_url')}complete/' +
            chapter.id.toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var jsonResponse = null;
    var response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse["user"]["point"]);
      setState(() {
        AppConfig.MAIN_USER.point = jsonResponse["user"]["point"];
      });
    } else {
      print("Fail");
    }
  }

  void loadFinich(Chapter chapter) async {
    final String url = '${GlobalConfiguration().getString('base_url')}finich/' +
        chapter.bookId.toString();
    print(url);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var jsonResponse = null;
    var response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse["user"]["point"]);
      setState(() {
        AppConfig.MAIN_USER.point = jsonResponse["user"]["point"];
      });
    } else {
      print("Fail");
    }
  }

  @override
  void initState() {
    loadPdfChapter(
      widget.chapters[widget.index],
    );
    setState(() {
      currentChapter = widget.index;
    });
    super.initState();
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
                    padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                    child: Container(
                      height: 100,
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
                                      urlimg + widget.book.cover,
                                      width: 55,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            widget
                                                .chapters[currentChapter].title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            widget.book.title,
                                            style: TextStyle(
                                              color: kLightBlackColor,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Text(
                                                "Total Chapters " +
                                                    widget.book.totalChapter
                                                        .toString()
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: kLightBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // margin: EdgeInsets.all(5),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(38.5),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 0),
                                            blurRadius: 5,
                                            color: Color(0xFFD3D3D3)
                                                .withOpacity(.84),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                          child: Text(widget
                                              .chapters[currentChapter].order
                                              .toString())),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //PDFViewer(document: doc)
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentChapter > 0
                          ? FlatButton(
                              onPressed: () {
                                setState(() {
                                  _isLoadingPDF = true;
                                  currentChapter--;
                                });
                                print(currentChapter);
                                loadPdfChapter(
                                  widget.chapters[currentChapter],
                                );
                              },
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              child: Text("Prev"),
                              color: kProgressIndicator,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      SizedBox(
                        width: 30,
                      ),
                      currentChapter < (widget.bookChaptres - 1)
                          ? FlatButton(
                              onPressed: () {
                                loadComplete(widget.chapters[currentChapter]);
                                setState(() {
                                  _isLoadingPDF = true;
                                  currentChapter++;
                                });
                                loadPdfChapter(widget.chapters[currentChapter]);
                              },
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              child: Text("Next"),
                              color: kProgressIndicator,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                            )
                          : SizedBox(
                              height: 10,
                            ),
                      currentChapter == (widget.bookChaptres - 1)
                          ? FlatButton(
                              onPressed: () {
                               loadFinich(widget.chapters[currentChapter - 1]);
                                loadComplete(
                                    widget.chapters[currentChapter - 1]);
                              },
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              child: Text("Finish"),
                              color: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 14),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Flexible(
                      child: _isLoadingPDF
                          ? Center(child: CircularProgressIndicator())
                          : PDFViewer(document: doc),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
