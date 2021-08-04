
import 'package:esprit_ebook_app/constants.dart';
import 'package:flutter/material.dart';

class BookRating extends StatefulWidget {
  final double score;
  const BookRating({
    Key key,
    this.score,
  }) : super(key: key);

  @override
  _BookRatingState createState() => _BookRatingState();
}

class _BookRatingState extends State<BookRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 7),
            blurRadius: 20,
            color: Color(0xFD3D3D3).withOpacity(.5),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.star,
            color: kIconColor,
            size: 15,
          ),
          SizedBox(height: 5),
          Text(
            "${widget.score}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
