import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/widgets/book_rating.dart';
import 'package:esprit_ebook_app/widgets/two_side_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class SearchItemWedget extends StatelessWidget {


  final String image;
  final String title;
  final String auth;
  final double rating;
  final Function pressDetails;
  final Function pressRead;

  const SearchItemWedget({
    Key key,
    this.image,
    this.title,
    this.auth,
    this.rating,
    this.pressDetails,
    this.pressRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
    return Container(
      margin: EdgeInsets.only(right: 24,left: 24, bottom: 40),
      height: 145,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 121,
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
            urlimg+image,
            width: 120,
          ),
          Positioned(
            top: 35,
            right: 10,
            child: Column(
              children: <Widget>[
                BookRating(score: rating),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              height: 85,
              width: 202,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: RichText(
                      maxLines: 5,
                      text: TextSpan(
                        style: TextStyle(color: kBlackColor),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: auth,
                            style: TextStyle(
                              color: kLightBlackColor,
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
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              width: 200,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Expanded(
                    child: TwoSideRoundedButton(
                      text: "Details",
                      press: pressDetails,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
