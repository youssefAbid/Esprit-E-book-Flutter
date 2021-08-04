import 'package:cached_network_image/cached_network_image.dart';
import 'package:esprit_ebook_app/constants.dart';
import 'package:esprit_ebook_app/models/cart.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {

  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget({Key key, this.cart, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);


  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dismissible(
      key: Key(widget.cart.id),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        child:


        Container(
          height: 115,
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
                    padding:
                    EdgeInsets.only(left: 30, right: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/book-1.png",
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
                                "Crushing & Influence",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Gary Venchuk",
                                style: TextStyle(
                                  color: kLightBlackColor,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.increment();
                                          });
                                        },
                                        iconSize: 30,
                                        //padding: EdgeInsets.symmetric(horizontal: 5),
                                        icon: Icon(Icons.add_circle_outline),
                                        color: Theme.of(context).hintColor,
                                      ),
                                      Text("1", style: Theme.of(context).textTheme.subtitle2),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.decrement();
                                          });
                                        },
                                        iconSize: 30,
                                        //padding: EdgeInsets.symmetric(horizontal: 5),
                                        icon: Icon(Icons.remove_circle_outline),
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),









                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

/*


        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.increment();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                      Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subtitle1),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.decrement();
                          });
                        },
                        iconSize: 30,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(Icons.remove_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),

*/
      ),
    );
  }
}
