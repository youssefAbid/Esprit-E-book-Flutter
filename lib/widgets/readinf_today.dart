import 'package:esprit_ebook_app/models/product.dart';
import 'package:esprit_ebook_app/screens/details_screen.dart';
import 'package:esprit_ebook_app/utils/app_config.dart';
import 'package:esprit_ebook_app/widgets/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class ReadingToDay extends StatefulWidget {
  final List<Product> books;
  ReadingToDay({Key key, @required this.books}) : super(key: key);
  @override
  _ReadingToDayState createState() => _ReadingToDayState();
}

class _ReadingToDayState extends State<ReadingToDay> {
  _buildBook(BuildContext context, Product book) {
    return ReadingListCard(
      id: book.id,
      image: book.cover,
      title: book.title,
      auth: book.author,
      rating: book.rates,
      pressDetails: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(book: book,);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[

          Container(
            height: 285,
           // width: 300,
            child: ListView.builder(
              scrollDirection:Axis.horizontal ,
                shrinkWrap: true,
                itemCount: widget.books.length,
                itemBuilder: (BuildContext context, int index) {
                  Product note = widget.books[index];
                  return _buildBook(context, note);
                }),
          ),
          // ReadingListCard(
          //   image: "assets/images/book-1.png",
          //   title: "Crushing & Influence",
          //   auth: "Gary Venchuk",
          //   rating: 4.9,
          //   pressDetails: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return DetailsScreen();
          //         },
          //       ),
          //     );
          //   },
          // ),

          SizedBox(width: 30),
        ],
      ),
    );
  }
}
