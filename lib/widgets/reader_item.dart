import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/cart.dart';
import 'package:esprit_ebook_app/models/reader.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

class ReaderItemWidget extends StatefulWidget {
  String heroTag;
  int index;
  Reader cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  ReaderItemWidget(
      {Key key,
        this.cart,
        this.index,
        this.heroTag,
        this.increment,
        this.decrement,
        this.onDismissed})
      : super(key: key);

  @override
  _ReaderItemWidgetState createState() => _ReaderItemWidgetState();
}

class _ReaderItemWidgetState extends State<ReaderItemWidget> {
  final String urlimg = '${GlobalConfiguration().getString('img_server')}book/';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: kProgressIndicator.withOpacity(1),
                        backgroundImage: NetworkImage(urlimg+widget.cart.user.avatar),
                        // child: Image.asset(
                        //   "assets/images/book-1.png",
                        //   width: 55,
                        // ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            widget.cart.user.fname+" "+widget.cart.user.lname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Points : "+widget.cart.user.point.toString(),
                            style: TextStyle(
                              color: kLightBlackColor,
                            ),
                          ),
                          Align(
                            alignment:
                            Alignment.bottomRight,
                            child: Text(
                              widget.cart.books.toString()+" Books",
                              style: TextStyle(
                                fontSize: 10,
                                color: kLightBlackColor,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                     // margin: EdgeInsets.all(5),
                      width: 40,
                      height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(38.5),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 5,
                              color: Color(0xFFD3D3D3).withOpacity(.84),
                            ),
                          ],
                        ),
                      child: Center(child: Text((widget.index+1).toString())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
