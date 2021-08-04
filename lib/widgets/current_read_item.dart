import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/chapter.dart';
import 'package:esprit_ebook_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class CurrentReadItem extends StatefulWidget {
  Chapter currentReading;
  CurrentReadItem({Key key, @required this.currentReading}) : super(key: key);
  @override
  _CurrentReadItemState createState() => _CurrentReadItemState();
}

class _CurrentReadItemState extends State<CurrentReadItem> {
  final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(book: widget.currentReading.book,);
            },
          ),
        );
      },
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
                          children: <Widget>[Text(
                              widget.currentReading
                                  .title,
                              style: TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            ), Text(
                            widget.currentReading
                                  .book.title,
                              style: TextStyle(
                                color:
                                kLightBlackColor,
                              ),
                            ),
                            Align(
                              alignment:
                              Alignment.bottomRight,
                              child: Text(
                                "Chapter " +
                                    widget.currentReading
                                        .order
                                        .toString() +
                                    " of "+widget.currentReading
                                    .book.totalChapter.toString(),
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
                        urlimg + widget.currentReading.book.cover,
                        width: 55,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 7,
                width: size.width * (widget.currentReading
                    .order / widget.currentReading.book.totalChapter),
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
    );
  }
}
