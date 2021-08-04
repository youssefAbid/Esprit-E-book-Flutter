import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/widgets/app_dialogs.dart';
import 'package:esprit_ebook_app/widgets/book_rating.dart';
import 'package:esprit_ebook_app/widgets/rate_dialog.dart';
import 'package:esprit_ebook_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadingListCard extends StatefulWidget {
  final int id;
  final String image;
  final String title;
  final String auth;
  final double rating;
  final Function pressDetails;
  final Function pressRead;

  const ReadingListCard({
    Key key,
    this.id,
    this.image,
    this.title,
    this.auth,
    this.rating,
    this.pressDetails,
    this.pressRead,
  }) : super(key: key);

  @override
  _ReadingListCardState createState() => _ReadingListCardState();
}

class _ReadingListCardState extends State<ReadingListCard> {
  final String url = '${GlobalConfiguration().getString('img_server')}book/';
  Dialogs dialog = new Dialogs();
  bool added = false;

  addFavorie(int id) async {
    final String url = '${GlobalConfiguration().getString('base_url')}fav';
    Map data = {'id': id};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final key = 'token';
    final value = sharedPreferences.get(key) ?? 0;
    print("Token From SP : " + value);
    var body = json.encode(data);
    var jsonResponse = null;
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $value"
        },body: body);
    print("APi Response Status : " + response.statusCode.toString());
    print("APi Response : " + response.body.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          added = true;
        });
        dialog.information(context, "Échouer", "Book Ete Ajoute To Fav");
      }
    } else if (response.statusCode == 500) {
      dialog.information(
          context, "Échouer", "Probleme De Connection a Serveur");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, bottom: 40),
      height: 245,
      width: 202,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 221,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 33,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
          ),
          Image.network(
            url+widget.image,
            width: 150,
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: !added
                      ? Icon(
                          Icons.favorite_border,
                        )
                      : Icon(
                          Icons.favorite,
                        ),
                  onPressed: () {
                    addFavorie(widget.id);
                  },
                ),
                InkWell(
                  onTap: (){
                    print("Hello");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return RateDialog(book: widget.id ,);
                        });
                  },
                    child: BookRating(score: widget.rating)),
              ],
            ),
          ),
          Positioned(
            top: 160,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: "${widget.title}\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.auth,
                            style: TextStyle(
                              color: kLightBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: <Widget>[
                      // GestureDetector(
                      //   onTap: pressDetails,
                      //   child: Container(
                      //     width: 101,
                      //     padding: EdgeInsets.symmetric(vertical: 10),
                      //     alignment: Alignment.center,
                      //     child: Text("Details"),
                      //   ),
                      // ),
                      Spacer(),
                      Expanded(
                        child: TwoSideRoundedButton(
                          text: "Details",
                          press: widget.pressDetails,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
