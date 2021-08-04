import 'package:esprit_ebook_app/data_static.dart';
import 'package:esprit_ebook_app/widgets/cart_bottom_details.dart';
import 'package:esprit_ebook_app/widgets/cart_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
        child: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'Shopping Cart',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                   "Verify your quantity and Click Checkout",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: carts.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    cart: carts.elementAt(index),
                    heroTag: 'cart',
                  );
                },
              ),
              CartBottomDetailsWidget()
            ],
          ),
        ),
      ),
    );
  }
}

